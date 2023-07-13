defmodule Honey.Utils do
  @moduledoc """
  Contains utility functions used across Honey-Potion.
  """

  @doc """
  Prefixes every string with info about the place where it was generated.
  Extremely useful for debugging generated code.
  """

  defmacro gen(text) do
    # TODO add tabulation and define beginning and end of generated parts
    %Macro.Env{file: file, line: line} = __CALLER__

    first_comment = "\n// ===== Generated at #{file}:#{line} ======"
    second_comment = gen_complement(String.length(first_comment)) <> "\n"

    quote do
      unquote(first_comment) <>
        unquote(__MODULE__).trim_and_wrap_line_breaks(unquote(text)) <>
        unquote(second_comment)
    end
  end

  defp gen_complement(num, equals_str \\ "// ") do
    if(String.length(equals_str) >= num - 1) do
      equals_str
    else
      gen_complement(num, equals_str <> "=")
    end
  end

  @doc """
  Trims and wraps a string with line break characters ("\n").
  It also guarantess that only one line break will exist in the beginning, and only one at the end.
  """

  def trim_and_wrap_line_breaks(text) when is_bitstring(text) do
    new_text =
      text
      |> String.trim()
      |> String.trim("\n")

    if(new_text == text) do
      "\n" <> new_text <> "\n"
    else
      trim_and_wrap_line_breaks(new_text)
    end
  end

  def ctx_var_to_generic(element) do
    var_name = "ctx_arg->#{Atom.to_string(element)}"
    "{.type = INTEGER, .value.integer = #{var_name}}"
  end

  @doc """
  Transforms a variable into a unique string.
  """
  def var_to_string({var_name, meta, var_context}) do
    "#{var_name}_#{inspect_no_limit(meta[:version])}_#{var_context}"
  end

  @doc """
  Transforms a variable into a unique atom.
  """
  def var_to_atom(var) do
    String.to_atom(var_to_string(var))
  end

  @doc """
  Transforms a variable into an unique atom. Mostly used as a key in keywords, maps and other structures with keys.
  """

  def var_to_key({var_name, meta, var_context}) do
    String.to_atom(var_to_string({var_name, meta, var_context}))
  end

  # Gets the value without limits in size or printing.
  defp inspect_no_limit(value) do
    inspect(value, limit: :infinity, printable_limit: :infinity)
  end

  @doc """
  Raises a compilation error in a standard format.
  """

  def compile_error!(%Macro.Env{line: line, file: file}, description) do
    raise CompileError, line: line, file: file, description: description
  end

  @doc """
  Returns the name of the module that we are translating.
  """

  def module_name(env) do
    mod_name = env.module
    mod_name = Atom.to_string(mod_name)
    "Elixir." <> mod_name = "#{mod_name}"
    mod_name
  end

  @doc """
  Returns the clang format stored in env.module.
  """

  def clang_format(env) do
    ebpf_options = Module.get_attribute(env.module, :ebpf_options)
    Keyword.get(ebpf_options, :clang_format)
  end

  # Guards to filter elements from the Elixir AST.
  @doc """
  Check if an AST node is a function call.
  """
  defguard is_call(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_list(:erlang.element(3, t))

  @doc """
  Check if an AST node is a variable.
  """
  defguard is_var(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_atom(:erlang.element(3, t))

  @doc """
  Check if an AST node is a constant. Note: this fails for explicit binaries, as the node is represent as {:<<>>, [...], [...]}
  """
  defguard is_constant(item)
           when is_number(item) or
                  is_bitstring(item) or
                  is_atom(item) or
                  is_binary(item) or
                  is_list(item) or
                  is_function(item) or
                  (is_tuple(item) and tuple_size(item) < 3)
end
