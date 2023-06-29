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
    CoreElixirToC
  }

  @moduledoc """
  Translates the elixir AST into readable eBPF C code. Provides the deft macro that allows the
  creation of new SEC, C library and Custom translators.
  """

  @doc """

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
    expected_func_name = :custom_ast_to_c

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
    possible_orders = [:unique, :overridable, :before, :after]

    if translation_order not in possible_orders do
      IO.puts(
        "The function custom_ast_to_c must be decorated with @translation_order, giving one of the possible orders: #{inspect(possible_orders)}"
      )

      raise "The function custom_ast_to_c must be decorated with @translation_order"
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
        check_call = change_func_name_in_ast!(call, :custom_ast_to_c_CHECK)

        quote do
          def unquote(call), unquote(expr)

          def unquote(check_call) do
            unquote(translation_order)
          end
        end
      end)

    {:__block__, [], ast_to_c_defs}
  end

  @doc """
  #Translates the main function.
  """

  def translate(func_name, ast, sec, license, elixir_maps) do
    case func_name do
      "main" ->
        Guard.ensure_sec_type!(sec)
        context = Honey.TranslatorContext.new(elixir_maps)
        translated_code = honeys_ast_to_c(ast, context)

        sec
        |> Boilerplates.config(["ctx_0_"], license, elixir_maps, translated_code)
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

  defp get_only_unique!(ast, context = %TranslatorContext{}) do
    Honey.ExportedCLibraries.get()
    |> Enum.reduce({nil, nil}, fn (current_module, {priority_module, priority_type}) ->
      custom_exists = Module.defines?(current_module, {:custom_ast_to_c_CHECK, 2}, :def)
      if(custom_exists and current_module.custom_ast_to_c_CHECK(ast, context) == :unique) do
        if(priority_module) do
          IO.puts("Modules #{priority_module} and #{current_module} have defined a :unique pattern on their custom_ast_to_c and both matched the ast below:")
          IO.inspect(ast)
          raise "Modules #{priority_module} and #{current_module} have defined a :unique pattern on their custom_ast_to_c and both matched an ast."
        end

        current_module
      end
    end)
  end

  @doc """
  """
  def honeys_ast_to_c(ast, context = %TranslatorContext{}) do
    ast = if(module = get_only_unique!(ast, context)) do
      module.custom_ast_to_c
    end
    CoreElixirToC.default_ast_to_c(ast, context)
  end

  @doc """
  Translates an Elixir AST to C, calling the right method given its priority, which are:
  1st. A module implementing a @translator_order as unique
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
          unquote(__CALLER__.module).custom_ast_to_c(unquote(ast), unquote(context))
        end

      :inclusive ->
        quote do
          unquote(__ENV__.module).honeys_ast_to_c(unquote(ast), unquote(context))
        end

      :exclusive ->
        # TODO
        raise "Translator.ast_to_c: The option :exclusive is still in development. Please chose another one."

      _ ->
        raise "Translator.ast_to_c: mode must be one of [:myself, :inclusive, :exclusive]."
    end
  end
end
