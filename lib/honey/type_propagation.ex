defmodule Honey.TypePropagation do
  import Honey.Utils, only: [var_to_key: 1, is_var: 1, is_constant: 1, var_to_atom: 1]
  alias Honey.{ElixirType, TypeSet, Info}

  @moduledoc """
  Propagates the type of variables throughout the elixir AST of the source program.
  Currently, it can exclusively execute in codes that only contains simple pattern matches, that is,
  the left-hand side should solely comprise a simple variable and should not be enclosed within a more
  complex structure, such as a tuple or array.
  """

  @doc """
  This function executes type propagation on an Elixir AST.
  """
  def run(ast, arguments, env = %Macro.Env{}) when is_list(arguments) do
    add_type_info(ast, arguments, env)
  end

  defp add_type_info(ast, arguments, env = %Macro.Env{}) when is_list(arguments) do
    # Get the type of the arguments
    {_ebpf_options, sec, _license, _maps} = Info.get_backend_info(env)

    tp_context =
      get_types_of_arguments(sec)
      |> Enum.zip(arguments)
      |> Enum.reduce(TPContext.new(env), fn {types, arg}, tp_context ->
        TPContext.add_var_types(tp_context, arg, TypeSet.new(types))
      end)

    {ast, tp_context} = Macro.postwalk(ast, tp_context, fn segment, tp_context ->
      case segment do
        {:=, meta, [lhs, rhs]} = pm ->
          if(is_var(lhs)) do
            rhs_typeset = get_typeset_from_segment(rhs, tp_context)

            new_rhs = add_types_to_segment(rhs, rhs_typeset)
            new_lhs = add_types_to_segment(lhs, rhs_typeset)

            new_pm =
              {:=, meta, [new_lhs, new_rhs]}
              |> add_types_to_segment(rhs_typeset)

            var_as_atom = var_to_atom(lhs)
            tp_context = TPContext.add_var_types(tp_context, var_as_atom, rhs_typeset)

            {new_pm, tp_context}
          else
            IO.puts(
              "Type propagation: Currently, we can only handle simple pattern matches, and the following structure was found:"
            )

            IO.inspect(Macro.to_string(pm))
            raise "Type propagation: Currently, we can only handle simple pattern matches."
          end

        segment ->
          seg_types = get_typeset_from_segment(segment, tp_context)
          new_seg = add_types_to_segment(segment, seg_types)

          tp_context =
            if(is_var(segment)) do
              TPContext.add_var_types(tp_context, segment, seg_types)
            else
              tp_context
            end

          {new_seg, tp_context}
      end
    end)
    # Return the ast without the accumulator.
    # |> elem(0)

    # IO.inspect(tp_context)
    ast
  end

  defp get_types_of_arguments(sec) do
    [ElixirType.new(:type_ctx)]
    # TODO: This will be implemented in the SEC file
  end

  defp get_typeset_from_segment(segment, context) do
    seg_types = TypeSet.get_typeset_from_var_ast(segment)

    cond do
      TypeSet.size(seg_types) != 0 ->
        seg_types

      is_var(segment) ->
        TPContext.get_types_of_var(context, segment)

      true ->
        extract_types_from_segment(segment, context)
    end
  end

  defp extract_types_from_segment(seg, _context) when is_constant(seg) do
    type =
      cond do
        is_float(seg) ->
          ElixirType.type_float()

        is_number(seg) ->
          ElixirType.type_integer()

        is_atom(seg) ->
          ElixirType.type_atom()

        is_binary(seg) ->
          ElixirType.type_binary()

        is_function(seg) ->
          ElixirType.type_function()

        is_list(seg) ->
          ElixirType.type_list()

        is_tuple(seg) ->
          ElixirType.type_tuple()

        true ->
          IO.puts("Type inferece: Could not identify the type of the structure:")
          IO.inspect(seg)
          raise "Type inferece: Could not identify the type of the structure."
      end

    TypeSet.new(type)
  end

  defp extract_types_from_segment({{:., _, [:erlang, function]}, _, [lhs, rhs]}, context) do
    lhs_types = get_typeset_from_segment(lhs, context)
    rhs_typeset = get_typeset_from_segment(rhs, context)

    type_integer = ElixirType.type_integer()
    type_float = ElixirType.type_float()

    cond do
      function == :+ or
        function == :- or
          function == :* ->
        for lhs_type <- lhs_types do
          for rhs_type <- rhs_typeset do
            case {lhs_type, rhs_type} do
              {^type_integer, ^type_integer} ->
                TypeSet.new(type_integer)

              {^type_integer, ^type_float} ->
                TypeSet.new(type_float)

              {^type_float, ^type_integer} ->
                TypeSet.new(type_float)

              {^type_float, ^type_float} ->
                TypeSet.new(type_float)

              _ ->
                TypeSet.new(ElixirType.type_invalid())
            end
          end
          |> TypeSet.new()
        end
        |> Enum.reduce(TypeSet.new(), &TypeSet.union/2)

      function == :/ ->
        for lhs_type <- lhs_types do
          for rhs_type <- rhs_typeset do
            case {lhs_type, rhs_type} do
              {^type_integer, ^type_integer} ->
                TypeSet.new(type_float)

              {^type_integer, ^type_float} ->
                TypeSet.new(type_float)

              {^type_float, ^type_integer} ->
                TypeSet.new(type_float)

              {^type_float, ^type_float} ->
                TypeSet.new(type_float)

              _ ->
                TypeSet.new(ElixirType.type_invalid())
            end
          end
          |> TypeSet.new()
        end
        |> Enum.reduce(TypeSet.new(), &TypeSet.union/2)

      function == :== or function == :=== or function == :!= or function == :!== ->
        TypeSet.new(ElixirType.type_boolean())

      true ->
        raise "Type propagation: Erlang function not supported: #{Atom.to_string(function)}"
    end
  end

  defp extract_types_from_segment({{:., _, [Honey.Bpf_helpers, function]}, _, params}, _context) do
    # TODO: Check if function exists
    func_data = apply(Honey.Bpf_helpers, function, params)

    if(!func_data) do
      TypeSet.new()
    else
      TypeSet.new(func_data.return_type)
    end
  end

  defp extract_types_from_segment({{:., _, [Honey.Helpers, function]}, _, params}, _context) do
    # TODO: Check if function exists
    func_data = apply(Honey.Helpers, function, params)

    if(!func_data) do
      TypeSet.new()
    else
      TypeSet.new(func_data.return_type)
    end
  end

  # Let's only accept one level for now. So var.field is allowed, but var.field1.field2 is not.
  defp extract_types_from_segment({{:., _, [{var_name, _, _} = var, field]}, _, _}, _context)
       when is_var(var) do
    var_types = TypeSet.get_typeset_from_var_ast(var)

    Enum.reduce(var_types, TypeSet.new(), fn type, typeset ->
      case type.name do
        :type_ctx ->
          case field do
            :data ->
              TypeSet.put_type(typeset, ElixirType.new(:type_ctx_data))

            :id ->
              TypeSet.put_type(typeset, ElixirType.new(:type_ctx_id))

            _ ->
              raise "Invalid field access. Tried accessing inexisting field '#{field}' of variable '#{var_name}'."
          end

        _ ->
          raise "Invalid field access. Tried accessing inexisting field '#{field}' of variable '#{var_name}'."
      end
    end)
  end

  defp extract_types_from_segment(seg, _context) do
    # IO.puts("Type propagation: We cannot analyze this structure yet:")
    # IO.inspect(seg)
    # raise "Type propagation: We cannot analyze this structure yet."
    TypeSet.new()
  end

  defp add_types_to_segment(segment, types_to_add) do
    current_types = TypeSet.get_typeset_from_var_ast(segment)
    new_types = TypeSet.union(current_types, types_to_add)
    Macro.update_meta(segment, &Keyword.put(&1, :types, new_types))
  end
end

defmodule TPContext do
  import Honey.Utils, only: [is_var: 1, var_to_atom: 1]
  alias Honey.{TypeSet}

  # var_types is a Keyword list.
  defstruct var_types: [], env: nil

  def new(env = %Macro.Env{}, var_types \\ []) when is_list(var_types) do
    %TPContext{var_types: var_types, env: env}
  end

  def get_types_of_var(tp_context, var_ast) when is_var(var_ast) do
    var_as_atom = var_to_atom(var_ast)
    get_types_of_var(tp_context, var_as_atom)
  end

  def get_types_of_var(tp_context, var_key) when is_atom(var_key) do
    Keyword.get(tp_context.var_types, var_key, TypeSet.new())
  end

  def add_var_types(tp_context, var_key, types = %TypeSet{}) when is_atom(var_key) do
    %TPContext{tp_context | var_types: [{var_key, types}] ++ tp_context.var_types}
  end

  def add_var_types(tp_context, var_ast, types = %TypeSet{}) when is_var(var_ast) do
    var_as_atom = var_to_atom(var_ast)
    add_var_types(tp_context, var_as_atom, types)
  end

  def set_var_types(tp_context, var_types) do
    %TPContext{tp_context | var_types: var_types}
  end
end