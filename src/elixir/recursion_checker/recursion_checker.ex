Code.require_file("callgraph.ex", ".")

defmodule RecursionChecker do
  def split_list(list) do
    {rest, last} = Enum.split(list, -1)

    case last do
      [] -> {rest, last}
      _ -> {rest, Enum.at(last, 0)}
    end
  end

  def get_called_funcs_from_do_block([do: lines], called_functions) do
    Enum.reduce(lines, called_functions, fn line, called_functions ->
      get_called_functions(line, called_functions)
    end)
  end

  def get_called_funcs_from_function_args(args, called_functions) do
    case args do
      [] ->
        called_functions

      _ ->
        Enum.reduce(args, called_functions, fn arg, called_funcs ->
          get_called_functions(arg, called_funcs)
        end)
    end
  end

  def get_called_functions_from_args(list_args, called_functions) do
    # Check if the last argument is a do block
    {args, last_arg} = split_list(list_args)

    is_do_block =
      case last_arg do
        [do: _] -> true
        _ -> false
      end

    called_functions =
      if is_do_block do
        called_functions = get_called_funcs_from_do_block(last_arg, called_functions)
        called_functions = get_called_funcs_from_function_args(args, called_functions)
        called_functions
      else
        get_called_funcs_from_function_args(list_args, called_functions)
      end

    called_functions
  end

  # Block
  # Blocks are represented as a __block__ call with each line as a separate argument
  def get_called_functions({:__block__, _b, lines}, called_functions) do
    Enum.reduce(lines, called_functions, fn line, called_functions ->
      get_called_functions(line, called_functions)
    end)
  end

  # Operators
  def get_called_functions({{:., _, list}, _b, args}, called_functions) do
    # IO.puts("PP: An operator.")
    _mod = Atom.to_string(Enum.at(list, 0))
    func = Atom.to_string(Enum.at(list, 1))

    called_functions = [func | called_functions]

    get_called_functions_from_args(args, called_functions)
  end

  # =
  def get_called_functions({:=, _b, [arg1, arg2]}, called_functions) do
    # IO.puts("PP: An operator.")

    called_functions = get_called_functions(arg1, called_functions)
    called_functions = get_called_functions(arg2, called_functions)

    called_functions
  end

  # Special functions

  def get_called_functions({:fn, _b, args}, called_functions) when is_list(args) do
    # "PP: A call."
    get_called_functions_from_args(args, called_functions)
  end

  def get_called_functions({:->, _, [left, ast]}, called_functions) do
    called_functions =
      Enum.reduce(left, called_functions, fn arg, called_functions ->
        get_called_functions(arg, called_functions)
      end)

    called_functions = get_called_functions(ast, called_functions)

    called_functions
  end

  # Calls to a local function
  def get_called_functions({fun_name, _b, args}, called_functions)
      when is_atom(fun_name) and is_list(args) do
    # "PP: A call."
    called_functions = [Atom.to_string(fun_name) | called_functions]
    called_functions = get_called_functions_from_args(args, called_functions)

    called_functions
  end

  # Tuple as first argument
  def get_called_functions({tuple, _b, _c}, called_functions) when is_tuple(tuple) do
    # "Tuple as first argument."
    called_functions
  end

  # Default
  def get_called_functions(_ast, called_functions) do
    # "PP: Something not predicted"
    called_functions
  end

  # TODO: Extract all functions in the module
  # It is currently a "phony" version because we're only extracting the functions
  # that has a name in the format "fx()", where x is a number.
  #At som
  defp phony_extract_functions(module_name, current_num, extracted_functions) do
    fun_name = "f" <> Integer.to_string(current_num)
    func_def = Module.get_definition(module_name, {String.to_atom(fun_name), 0})

    if func_def != nil do
      extracted_functions = [Fun.new(fun_name, func_def) | extracted_functions]
      phony_extract_functions(module_name, current_num + 1, extracted_functions)
    else
      extracted_functions
    end
  end

  defp phony_extract_functions(module_name) do
    funcs = phony_extract_functions(module_name, 1, [])
    Enum.reverse(funcs)
  end

  # Currently it only analyzes calls to functions in the same module.
  def is_recursive?(module_name) do
    # Get the function infos
    function_infos = phony_extract_functions(module_name)

    # Create the Call Graph:
    cg =
      Enum.reduce(function_infos, CallGraph.new(), fn func_info, cg ->
        CallGraph.add_function(cg, func_info)
      end)

    # Add edges to the call graph:
    cg =
      Enum.reduce(cg.nodes, cg, fn node, cg ->
        node_name = node.fun.name

        #TODO: Analyze all clauses of the function, instead of just the first one

        {:v1, _kind, _metadata, [clause | _other_clauses]} = node.fun.definition
        {_metadata, _arguments, _guards, func_ast} = clause

        called_functions = get_called_functions(func_ast, [])

        Enum.reduce(called_functions, cg, fn called_func_name, cg ->
          CallGraph.connect_functions(cg, node_name, called_func_name)
        end)
      end)

    CallGraph.print(cg)
    CallGraph.is_recursive?(cg)
  end
end
