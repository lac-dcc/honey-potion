defmodule Honey.Utils do
  @moduledoc """
  Contains utility functions used across Honey-Potion.
  """

  @doc """
  Prefixes every string with info about the place where it was generated.
  Extremely useful for debugging generated code.
  """
  defmacro gen(text) do
    %Macro.Env{file: file, line: line} = __CALLER__

    # TODO add tabulation and define beginning and end of generated parts
    quote do
      "// Generated at #{unquote(file)}:#{unquote(line)}\n" <> unquote(text)
    end
  end

  @doc """
  Transforms a variable into an unique string.
  """
  def var_to_string({var_name, meta, var_context}) do
    "#{var_name}_#{inspect_no_limit(meta[:version])}_#{var_context}"
  end

  @doc """
  Transforms a variable into an unique atom. Mostly used as a key in keywords, maps and other structures with keys.
  """
  def var_to_key({var_name, meta, var_context}) do
    String.to_atom(var_to_string({var_name, meta, var_context}))
  end

  @doc """
  Transforms a variable into a unique atom.
  """
  def var_to_atom(var) do
    String.to_atom(var_to_string(var))
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

  def ctx_var_to_generic(element) do
    var_name = "ctx_arg->#{Atom.to_string(element)}"
    "{.type = INTEGER, .value.integer = #{var_name}}"
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
  Guard for Function calls.
  """
  defguard is_call(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_list(:erlang.element(3, t))

  @doc """
  Guard for Variables.
  """
  defguard is_var(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_atom(:erlang.element(3, t))

  @doc """
  Guard for Constants.
  """
  defguard is_constant(item)
           when is_number(item) or
                  is_bitstring(item) or
                  is_atom(item) or
                  is_binary(item) or
                  is_boolean(item) or
                  is_nil(item)
end
