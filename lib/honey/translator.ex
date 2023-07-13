defmodule Honey.TranslatorContext do
  defstruct [:maps, :sec_module, :c_libraries_modules, :user_custom_translators]

  def new(maps) do
    %__MODULE__{maps: maps}
  end
end

defmodule Honey.Translator do
  alias Honey.{
    TranslatorContext,
    Boilerplates,
    Guard,
    CoreElixirToC,
    Utils
  }

  @moduledoc """
  Translates the elixir AST into readable eBPF C code. Provides the deft macro that allows the
  creation of new SEC, C library and Custom translators.
  """

  defp get_function_ast_without_guards!(func_ast) do
    case func_ast do
      {:when, _, [func_def = {_, _, _} | _]} ->
        func_def

      {_, _, _} ->
        func_ast

      _ ->
        IO.puts("Invalid function ast passed to get_function_ast_without_guards!:")
        IO.inspect(func_ast)
        raise "Invalid function ast passed to get_function_ast_without_guards!"
    end
  end

  defp change_func_name_in_ast!(func_ast, new_name) when is_atom(new_name) do
    case func_ast do
      {:when, _, [{_func_name, _, _} | _]} ->
        put_in(func_ast, [Access.elem(2), Access.at!(0), Access.elem(0)], new_name)

      {_func_name, _, _} ->
        put_in(func_ast, [Access.elem(0)], new_name)

      _ ->
        IO.puts("Invalid function ast passed to change_func_name_in_ast!:")
        IO.inspect(func_ast)
        raise "Invalid function ast passed to change_func_name_in_ast!"
    end
  end

  defp assert_deft_structure!(call, expr) do
    expected_func_name = :ast_to_c

    example_of_deft =
      "@translation_order order\n" <>
        "deft #{expected_func_name}(segment, context) do\n" <>
        "    #...\n" <>
        "end"

    func_def_ast = get_function_ast_without_guards!(call)

    # Check if the name and parameters are passed correctly
    with {:func_name, {^expected_func_name, _, _}} <- {:func_name, func_def_ast},
         {:num_args, {_, _, [_, _]}} <- {:num_args, func_def_ast},
         {:do_block, [do: _]} <- {:do_block, expr} do
    else
      {:func_name, _} ->
        err =
          "deft must be used with the name #{expected_func_name}, like: \n\n" <>
            example_of_deft

        IO.puts(err)

        raise "deft must be used with the name #{expected_func_name}"

      {:num_args, _} ->
        err =
          "deft function must receive two arguments: an elixir ast segment and a Honey.TranslatorContext, like: \n\n" <>
            example_of_deft

        IO.puts(err)

        raise "deft function must receive two arguments: an elixir ast segment and a Honey.TranslatorContext"

      {:do_block, _} ->
        IO.inspect(expr)
        raise "(CompileError) missing :do option in \"deft\""
    end
  end

  defp assert_valid_translation_order!(translation_order) do
    possible_orders = [:high, :normal, :before, :after]

    if translation_order not in possible_orders do
      IO.puts(
        "The function ast_to_c must be decorated with @translation_order, giving one of the possible orders: #{inspect(possible_orders)}"
      )

      raise "The function ast_to_c must be decorated with @translation_order"
    end
  end

  @doc """
  """
  defmacro deft(call, expr \\ nil) do
    assert_deft_structure!(call, expr)

    quote do
      @ast_to_c_definitions {@translation_order || @default_translation_order,
                             unquote(Macro.escape(call)), unquote(Macro.escape(expr))}
      @translation_order nil
    end
  end

  @doc """
  """
  defmacro __using__(_options) do
    if length(Module.get_attribute(__CALLER__.module, :before_compile)) != 0 do
      raise "Honey: Module #{__CALLER__.module} has already set the before_compile attribute."
    end

    Module.register_attribute(__CALLER__.module, :ast_to_c_definitions, accumulate: true)

    quote do
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
      @default_translation_order nil
      @translation_order nil
    end
  end

  @doc """

  """
  defmacro __before_compile__(env) do
    ast_to_c_defs =
      Module.get_attribute(env.module, :ast_to_c_definitions)
      |> Enum.reverse()
      |> Enum.map(fn {translation_order, call, expr} ->
        assert_valid_translation_order!(translation_order)
        check_call = change_func_name_in_ast!(call, :ast_to_c_CHECK)

        quote do
          # unquote real ast_to_c
          def unquote(call), unquote(expr)

          # unquote the ast_to_c_CHECK
          def unquote(check_call) do
            unquote(translation_order)
          end

          #
          def ast_to_c_CHECK(_, _) do
            false
          end
        end
      end)
  end

  @doc """
  #Translates the main function.
  """

  def translate(func_name, ast, sec_name, license, elixir_maps) do
    case func_name do
      "main" ->
        context = Honey.TranslatorContext.new(elixir_maps)
        translated_code = honeys_ast_to_c(ast, context)

        Honey.ExportedSecs.get_from_sec_name!(sec_name)
        |> Boilerplates.config("ctx_arg", license, elixir_maps, translated_code)
        |> Boilerplates.generate_whole_code()

      _ ->
        false
    end
  end

  @doc """
  Generates a string with the format "helper_var_<UniqueNumber>" to be used as an unique variable.
  """
  def unique_helper_var() do
    "helper_var_#{:erlang.unique_integer([:positive])}"
  end

  def unique_helper_label() do
    "label_#{:erlang.unique_integer([:positive])}"
  end

  defp get_module_ast_to_c!(ast, context = %TranslatorContext{}) do
    # TODO: Improve the complexity of this function...
    # TODO: Accept user-defined modules

    c_libraries_modules =
      Honey.ExportedCLibraries.get()
      |> Enum.reverse()

    sec_modules =
      Honey.ExportedSecs.get()
      |> Enum.reverse()

    {right_module, _} =
      c_libraries_modules
      |> Enum.concat(sec_modules)
      |> Enum.reduce({nil, nil}, fn current_module, {selected_module, selected_priority} ->
        current_priority =
          Kernel.function_exported?(current_module, :ast_to_c_CHECK, 2) &&
            current_module.ast_to_c_CHECK(ast, context)

        case current_priority do
          false ->
            {selected_module, selected_priority}

          :high ->
            if selected_priority == :high do
              IO.puts(
                "Modules #{selected_module} and #{current_module} have defined a :high pattern on their ast_to_c and both matched the ast below:"
              )

              IO.inspect(ast)

              raise "Modules #{selected_module} and #{current_module} have defined a :high pattern on their ast_to_c and both matched an ast."
            else
              {current_module, current_priority}
            end

          :normal ->
            {current_module, current_priority}
        end
      end)

    right_module = right_module || CoreElixirToC
  end

  @doc """
  """
  def honeys_ast_to_c(ast, context = %TranslatorContext{}) do
    module = get_module_ast_to_c!(ast, context)

    ast =
      try do
        module.ast_to_c(ast, context)
      rescue
        # To my understanding, if it gets to this point, it's because it reached CoreElixirToC and not even it implements this ast pattern
        FunctionClauseError ->
          IO.puts(
            "Honey is not capable of translating this AST pattern yet:"
          )

          IO.inspect(ast)

          raise "Honey is not capable of translating this AST pattern yet."
      end

    ast
  end

  @doc """
  Translates an Elixir AST to C, calling the right method given its priority, which are:
  1st. A module implementing a @translator_order as :high
  2nd. User-defined translation
  3rd. SEC-defined translation
  4th. C library-defined translation
  5th. Default translation
  """
  defmacro ast_to_c(ast, context = %TranslatorContext{}, mode \\ :inclusive) do
    # TODO: Check if ast are valid.

    case mode do
      :myself ->
        quote do
          unquote(__CALLER__.module).ast_to_c(unquote(ast), unquote(context))
        end

      :inclusive ->
        quote do
          unquote(__MODULE__).honeys_ast_to_c(unquote(ast), unquote(context))
        end

      :exclusive ->
        # TODO
        raise "Translator.ast_to_c: The option :exclusive is still in development. Please chose another one."

      _ ->
        raise "Translator.ast_to_c: mode must be one of [:myself, :inclusive, :exclusive]."
    end
  end
end
