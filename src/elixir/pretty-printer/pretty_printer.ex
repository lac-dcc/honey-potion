defmodule PrettyPrinter do
  defp add_indent(str) do
    String.replace(str, "\n", "\n  ")
  end

  def split_list(list) do
    {rest, last} = Enum.split(list, -1)

    case last do
      [] -> {rest, last}
      _ -> {rest, Enum.at(last, 0)}
    end
  end

  def do_block_to_string([do: lines], _parens \\ true) do
    lines_str =
      for line <- lines do
        ast_to_string(line)
      end

    "do" <>
      (("\n" <> Enum.join(lines_str, "\n")) |> add_indent()) <>
      "\nend"
  end

  def function_args_to_string(args, parens \\ true) do
    case args do
      [] ->
        "()"

      _ ->
        args_str =
          for arg <- args do
            ast_to_string(arg)
          end

        list = Enum.join(args_str, ", ")

        if parens do
          "(" <> list <> ")"
        else
          list
        end
    end
  end

  def args_ast_to_string(list_args, parens \\ true) do
    # Check if the last argument is a do block
    {args, last_arg} = split_list(list_args)

    is_do_block =
      case last_arg do
        [do: _] -> true
        _ -> false
      end

    {do_block, other_args} =
      if is_do_block do
        {do_block_to_string(last_arg, parens), function_args_to_string(args, parens)}
      else
        {"", function_args_to_string(list_args, parens)}
      end

    other_args <> " " <> do_block
  end

  def ast_to_string(atom) when is_atom(atom) do
    # "PP: An atom."
    ":" <> Atom.to_string(atom)
  end

  def ast_to_string(int) when is_integer(int) do
    # "PP: An integer."
    Integer.to_string(int)
  end

  def ast_to_string(float) when is_float(float) do
    # "PP: A float."
    Float.to_string(float)
  end

  def ast_to_string(string) when is_bitstring(string) do
    # "PP: A bitstring."
    string
  end

  def ast_to_string(string) when is_list(string) do
    # "PP: A list."
    string
  end

  def ast_to_string({_a, _b} = _tuple) do
    "PP: A tuple with two elements."
    # tuple
  end

  # Variable
  def ast_to_string({var_name, _b, c}) when is_atom(var_name) and is_atom(c) do
    # "PP: A variable."
    Atom.to_string(var_name)
  end

  # Block
  # Blocks are represented as a __block__ call with each line as a separate argument
  def ast_to_string({:__block__, _b, lines}) do
    # IO.puts("PP: A call.")
    list_lines_str =
      for line <- lines do
        ast_to_string(line)
      end

    lines_str = Enum.join(list_lines_str, "\n")

    "(" <>
      add_indent("\n" <> lines_str) <>
      "\n)"
  end

  # Operators
  def ast_to_string({{:., _, list}, _b, args}) do
    # IO.puts("PP: An operator.")
    mod = Atom.to_string(Enum.at(list, 0))
    func = Atom.to_string(Enum.at(list, 1))

    result = ":\"" <> mod <> "\"." <> func

    result <> args_ast_to_string(args)
  end

  # =
  def ast_to_string({:=, _b, [arg1, arg2]}) do
    # IO.puts("PP: An operator.")

    ast_to_string(arg1) <> " = " <> ast_to_string(arg2)
  end

  # Special functions

  def ast_to_string({:fn, _b, args}) when is_list(args) do
    # "PP: A call."
    "fn " <> args_ast_to_string(args, false) <> "\nend"
  end

  def ast_to_string({:->, _, [left, ast]}) do
    # asts_to_str = for ast <- list_of_asts do
    #   asts_to_str(ast)
    # end

    list_left_string =
      for arg <- left do
        ast_to_string(arg)
      end

    Enum.join(list_left_string, ", ") <> " -> " <> add_indent("\n" <> ast_to_string(ast))
  end

  # Calls to a local function
  def ast_to_string({fun_name, _b, args}) when is_atom(fun_name) and is_list(args) do
    # "PP: A call."
    Atom.to_string(fun_name) <> args_ast_to_string(args)
  end

  # Tuple as first argument
  def ast_to_string({tuple, _b, _c}) when is_tuple(tuple) do
    # IO.puts("PP: An operator.")
    "Tuple as first argument."
  end

  # Default
  def ast_to_string(_ast) do
    "PP: Something not predicted"
    # "\nPP: Something not predicted:"
    # <> inspect(ast, pretty: true)
    # <> "PP: End of something not predicted.\n"
  end

  def print_clauses([]) do
    :nothing
  end

  def print_clauses([clause | other_clauses]) do
    {_metadata, _arguments, _guards, ast} = clause
    IO.puts(ast_to_string(ast))
    # IO.inspect(ast)
    print_clauses(other_clauses)
  end

  def print(module_definition) do
    {_version, _kind, _metadata, clauses} = module_definition
    print_clauses(clauses)
  end

  def print_with_macro_to_string(module_definition) do
    {_version, _kind, _metadata, clauses} = module_definition

    for {_metadata, _arguments, _guards, ast} <- clauses do
      IO.puts(Macro.to_string(ast))
    end
  end

  def complete_print(function_definition) do
    IO.puts("=================\nModule definition:")
    IO.puts("")
    IO.inspect(function_definition)

    IO.puts("=================\nMacro.to_string:")
    IO.puts("")
    # IO.inspect(function_definition)
    print_with_macro_to_string(function_definition)

    IO.puts("\n\n\n=================\nMy pretty printer:")
    IO.puts("")
    print(function_definition)
    IO.puts("")
    IO.puts("\n\n\n=================\n\n\n")
  end
end
