defmodule Honey.Utils do
  # So this macro basically prefixes every string with info about a place
  # where it was generated. Extremely useful for debugging generated code
  #
  # PS
  # I just don't like sigils, because macro can have an english name
  # while sigil is just one char, which makes no sense for readers
  defmacro gen(text) do
    %Macro.Env{file: file, line: line} = __CALLER__

    # TODO add tabulation and define beginning and end of generated parts
    quote do
      "// Generated at #{unquote(file)}:#{unquote(line)}\n" <> unquote(text)
    end
  end

  def var_to_string({var_name, meta, var_context}) do
    "#{var_name}#{inspect_no_limit(meta[:version])}#{var_context}"
  end

  defp inspect_no_limit(value) do
    inspect(value, limit: :infinity, printable_limit: :infinity)
  end

  def compile_error!(%Macro.Env{line: line, file: file}, description) do
    raise CompileError, line: line, file: file, description: description
  end

  defguard is_call(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_list(:erlang.element(3, t))

  defguard is_var(t)
           when is_tuple(t) and
                  tuple_size(t) == 3 and
                  is_atom(:erlang.element(1, t)) and
                  is_list(:erlang.element(2, t)) and
                  is_atom(:erlang.element(3, t))

  defguard is_constant(item)
           when is_number(item) or
                  is_bitstring(item) or
                  is_atom(item) or
                  is_binary(item) or
                  is_boolean(item) or
                  is_nil(item)
end
