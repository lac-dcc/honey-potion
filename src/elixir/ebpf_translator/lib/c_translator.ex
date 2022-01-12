import GVA

defmodule TranslatedCode do
  defstruct [:code, :return_var_name]

  def new(code \\ "", return_var_name \\ "0var_name_err") do
    %TranslatedCode{code: code, return_var_name: return_var_name}
  end
end

defmodule Translator do
  def get_c_var_name(var_ast) do
    {var_name, meta, var_context} = var_ast

    Atom.to_string(var_name) <>
      inspect_no_limit(meta[:version]) <>
      Atom.to_string(var_context)
  end

  def get_new_helper_var_name() do
    counter = gget(:global_var, :helper_var_counter)
    gput(:global_var, :helper_var_counter, counter + 1)
    "helper_var_#{counter}"
  end

  defp inspect_no_limit(value) do
    Kernel.inspect(value, limit: :infinity, printable_limit: :infinity)
  end

  def to_c(tree, context \\ {})

  # Variables
  def to_c({var, var_meta, var_context}, _context) when is_atom(var) and is_atom(var_context) do
    return_var_name = get_c_var_name({var, var_meta, var_context})
    TranslatedCode.new("", return_var_name)
  end

  # Blocks
  def to_c({:__block__, _, [expr]}, context) do
    to_c(expr, context)
  end

  def to_c({:__block__, _, _} = ast, context) do
    block = block_to_c(ast, context)
    %TranslatedCode{block | code: "\n" <> block.code <> "\n"}
  end

  # Erlang functions
  def to_c({{:., _, [:erlang, function]}, _, [lhs, rhs]}, _context) do
    func_string =
      case function do
        :+ ->
          " + "

        :- ->
          " - "

        :* ->
          " * "

        :== ->
          " == "

        :> ->
          " > "

        :>= ->
          " >= "

        :< ->
          " < "

        :<= ->
          " <= "

        _ ->
          raise "Erlang function not supported: #{Atom.to_string(function)}"
      end

    lhs_in_c = to_c(lhs)
    rhs_in_c = to_c(rhs)

    c_var_name = get_new_helper_var_name()

    code =
      lhs_in_c.code <>
        "\n" <>
        rhs_in_c.code <>
        "\n" <>
        "int #{c_var_name} = " <>
        lhs_in_c.return_var_name <> func_string <> rhs_in_c.return_var_name <> ";" <> "\n"

    TranslatedCode.new(code, c_var_name)
  end

  # Match operator, not complete
  def to_c({:=, _, [lhs, rhs]}, _context) do
    rhs_in_c = to_c(rhs)

    c_var_name = get_c_var_name(lhs)

    code =
      rhs_in_c.code <> "\n" <> "int " <> c_var_name <> " = " <> rhs_in_c.return_var_name <> ";\n"

    TranslatedCode.new(code, c_var_name)
  end

  # Cond
  def to_c({:cond, _, [[do: conds]]}, _context) do
    cond_var_name_in_c = get_new_helper_var_name()

    cond_code = cond_statments_to_c(conds, cond_var_name_in_c)

    code = "int #{cond_var_name_in_c} = 0;" <> cond_code
    TranslatedCode.new(code, cond_var_name_in_c)
  end

  # Other structures
  def to_c(other, _context) do
    {is_cons, cons_type, cons_value_in_c} = is_constant(other)

    if(is_cons) do
      if(cons_type != "int") do
        raise "All values in the program must be integers. Received #{cons_type}: #{cons_value_in_c}"
      end

      c_var_name = get_new_helper_var_name()

      code = "int #{c_var_name} = #{cons_value_in_c};"

      TranslatedCode.new(code, c_var_name)
    else
      IO.puts("We cannot convert this structure yet:")
      IO.inspect(other)
      raise "We cannot convert this structure yet."
    end
  end

  def is_constant(item) do
    cond do
      is_integer(item) ->
        {true, "int", "#{item}"}

      is_number(item) ->
        {true, "double", "#{item}"}

      is_bitstring(item) ->
        {true, "string", "\"#{item}\""}

      is_boolean(item) ->
        {true, "int", if(item, do: "1", else: "0")}

      is_nil(item) ->
        raise "We cannot convert nil yet."

      is_atom(item) ->
        raise "We cannot convert atoms yet."

      is_binary(item) ->
        raise "We cannot convert binary yet."

      true ->
        {false, nil, nil}
    end
  end

  def cond_statments_to_c([], cond_var_name_in_c) do
    "#{cond_var_name_in_c} = 0;"
  end

  def cond_statments_to_c([cond_stat | other_conds], cond_var_name_in_c) do
    {:->, _, [[condition] | [block]]} = cond_stat
    condition_in_c = to_c(condition)

    block_in_c = to_c(block)

    condition_in_c.code <>
      "\n" <>
      "if (#{condition_in_c.return_var_name}) {\n" <>
      block_in_c.code <>
      "\n" <>
      "#{cond_var_name_in_c} = #{block_in_c.return_var_name};\n}\n" <>
      "else {\n" <>
      cond_statments_to_c(other_conds, cond_var_name_in_c) <> "\n}\n"
  end

  defp block_to_c({:__block__, _, exprs}, context) do
    Enum.reduce(exprs, TranslatedCode.new(), fn expr, translated_so_far ->
      translated_expr = to_c(expr, context)

      %TranslatedCode{
        translated_expr
        | code: translated_so_far.code <> "\n" <> translated_expr.code
      }
    end)
  end

  defp get_c_function_definition(func_name) do
    case func_name do
      "main" ->
        "int main() {\n"

      _ ->
        raise "Currently, it only translates the main function." <> func_name
    end
  end

  def translate(ast, func_name) do
    if(func_name == "main") do
      # TODO: replace this global counter with something more idiomatic in elixir
      gnew(:global_var)
      gput(:global_var, :helper_var_counter, 0)

      %TranslatedCode{code: function_code_in_c, return_var_name: return_var_name} = to_c(ast)

      code_in_c =
        get_c_function_definition(func_name) <>
          function_code_in_c <>
          "return #{return_var_name};" <>
          "\n" <>
          "}"

      {:ok, file} = File.open("translated_c.c", [:write])
      IO.binwrite(file, code_in_c)
      File.close(file)

      # Optional, format the file using clang-format:
      # System.cmd("/usr/lib/llvm_versions/llvm-11/build/bin/clang-format", ["-i", "translated_c.c"])

      true
    else
      false
    end
  end
end
