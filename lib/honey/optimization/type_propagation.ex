defmodule Honey.Optimization.TypePropagation do
  @moduledoc """
  Propagates the type of variables throughout the elixir AST of the source program.
  Currently, it can exclusively execute in codes that only contains simple pattern matches, that is,
  the left-hand side should solely comprise a simple variable and should not be enclosed within a more
  complex structure, such as a tuple or array.
  """
  # alias Mix.Tasks.Lsp.DataModel.Type wasn't moved in
  alias Honey.Analysis.ElixirTypes
  alias Honey.Runtime.Info
  alias Honey.TypeSet

  import Honey.Utils.Core, only: [var_to_key: 1, is_var: 1, is_constant: 1, var_to_atom: 1]

  @doc """
  This function executes type propagation on an Elixir AST.
  """
  def run(ast, arguments, env = %Macro.Env{}) when is_list(arguments) do
    add_type_info(ast, arguments, env)
  end

  defp add_type_info(ast, arguments, env = %Macro.Env{}) when is_list(arguments) do
    # Get the type of the arguments
    {_ebpf_options, sec_module, _license, _maps} = Info.get_backend_info(env)

    tp_context =
      get_types_of_arguments(sec_module)
      |> Enum.zip(arguments)
      |> Enum.reduce(TPContext.new(env), fn {types, arg}, tp_context ->
        TPContext.add_var_types(tp_context, arg, TypeSet.new(types))
      end)

    {ast, _tp_context} =
      Macro.postwalk(ast, tp_context, fn segment, tp_context ->
        case segment do
          {:=, meta, [lhs, rhs]} = _pm ->
            {rhs_typeset, typed_args, tp_context} =
              resolve_typeset_from_match([lhs, rhs], tp_context)

            typed_args = Tuple.to_list(typed_args)

            new_pm =
              {:=, meta, typed_args}
              |> add_types_to_segment(rhs_typeset)

            {new_pm, tp_context}

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

  defp get_types_of_arguments(_sec_module) do
    [ElixirTypes.new(:type_ctx)]
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
          ElixirTypes.type_float()

        is_number(seg) ->
          ElixirTypes.type_integer()

        is_atom(seg) ->
          ElixirTypes.type_atom()

        is_binary(seg) ->
          ElixirTypes.type_binary()

        is_function(seg) ->
          ElixirTypes.type_function()

        is_list(seg) ->
          ElixirTypes.type_list()

        is_tuple(seg) ->
          ElixirTypes.type_tuple()

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

    type_integer = ElixirTypes.type_integer()
    type_float = ElixirTypes.type_float()

    cond do
      function == :+ or
        function == :- or
          function == :* ->
        for lhs_type <- lhs_types do
          for rhs_type <- rhs_typeset do
            case {lhs_type, rhs_type} do
              {^type_integer, ^type_integer} ->
                type_integer

              {^type_integer, ^type_float} ->
                type_float

              {^type_float, ^type_integer} ->
                type_float

              {^type_float, ^type_float} ->
                type_float

              _ ->
                ElixirTypes.type_invalid()
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
                TypeSet.new(ElixirTypes.type_invalid())
            end
          end
          |> TypeSet.new()
        end
        |> Enum.reduce(TypeSet.new(), &TypeSet.union/2)

      function == :== or function == :=== or function == :!= or function == :!== ->
        TypeSet.new(ElixirTypes.type_boolean())

      true ->
        raise "Type propagation: Erlang function not supported: #{Atom.to_string(function)}"
    end
  end

  defp extract_types_from_segment({{:., _, [Honey.BpfHelpers, function]}, _, _params}, _context) do
    # # TODO: Check if function exists
    # func_type = apply(Honey.BpfHelpers, function, params)

    # if(!func_type) do
    #   TypeSet.new()
    # else
    #   TypeSet.new(func_type)
    # end
    case function do
      :bpf_printk -> TypeSet.new(ElixirTypes.type_integer())
      :bpf_get_current_pid_tgid -> TypeSet.new(ElixirTypes.type_integer())
      :bpf_map_update_elem -> TypeSet.new(ElixirTypes.type_integer())
      :bpf_map_lookup_elem -> TypeSet.new(ElixirTypes.type_integer())
      _ -> TypeSet.new()
    end
  end

  defp extract_types_from_segment({{:., _, [Honey.XDP, function]}, _, _params}, _context) do
    case function do
      :drop -> TypeSet.new(ElixirTypes.type_integer())
      :pass -> TypeSet.new(ElixirTypes.type_integer())
    end
  end

  defp extract_types_from_segment({{:., _, [Honey.Ethhdr, function]}, _, _params}, _context) do
    case function do
      :init -> TypeSet.new(ElixirTypes.type_invalid())
      :const_udp -> TypeSet.new(ElixirTypes.type_integer())
      :ip_protocol -> TypeSet.new(ElixirTypes.type_integer())
      :destination_port -> TypeSet.new(ElixirTypes.type_integer())
      :set_destination_port -> TypeSet.new(ElixirTypes.type_integer())
      :h_source -> TypeSet.new(ElixirTypes.type_void())
      _ -> TypeSet.new()
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
              TypeSet.put_type(typeset, ElixirTypes.new(:type_ctx_data))

            :id ->
              TypeSet.put_type(typeset, ElixirTypes.type_integer())

            :sig ->
              TypeSet.put_type(typeset, ElixirTypes.type_integer())

            :pid ->
              TypeSet.put_type(typeset, ElixirTypes.type_integer())

            _ ->
              raise "Invalid field access. Tried accessing inexisting field '#{field}' of variable '#{var_name}'."
          end

        _ ->
          raise "Invalid field access. Tried accessing inexisting field '#{field}' of variable '#{var_name}'."
      end
    end)
  end

  defp extract_types_from_segment(_seg, _context) do
    # Segments that fall into this have no type. This includes __block__, :->, etc. Ideally we don't fall back into this in the future.
    TypeSet.new()
  end

  defp add_types_to_segment(segment, types_to_add) do
    current_types = TypeSet.get_typeset_from_var_ast(segment)
    new_types = TypeSet.union(current_types, types_to_add)
    Macro.update_meta(segment, &Keyword.put(&1, :types, new_types))
  end

  # Base case. If lhs is a variable we add it to types context.
  defp resolve_typeset_from_match([lhs, rhs], tp_context)
       when is_var(lhs) do
    rhs_typeset = get_typeset_from_segment(rhs, tp_context)

    typed_rhs = add_types_to_segment(rhs, rhs_typeset)
    typed_lhs = add_types_to_segment(lhs, rhs_typeset)

    typed_args = {typed_lhs, typed_rhs}

    var_as_atom = var_to_atom(lhs)
    tp_context = TPContext.add_var_types(tp_context, var_as_atom, rhs_typeset)

    {rhs_typeset, typed_args, tp_context}
  end

  # Base case. If rhs is a variable we can't expand anymore.
  # This isn't implemented properly yet!!! That is why it returns invalid type.
  defp resolve_typeset_from_match([lhs, rhs], tp_context)
       when is_var(rhs) do
    rhs_typeset = get_typeset_from_segment(rhs, tp_context)

    typed_rhs = add_types_to_segment(rhs, rhs_typeset)
    typed_lhs = add_types_to_segment(lhs, TypeSet.new(ElixirTypes.type_invalid()))

    typed_args = {typed_lhs, typed_rhs}

    # var_as_atom = var_to_atom(lhs)
    # tp_context = TPContext.add_var_types(tp_context, var_as_atom, rhs_typeset) #lhs isn't a variable.

    {rhs_typeset, typed_args, tp_context}
  end

  # Base case. If lhs is constant we are done.
  defp resolve_typeset_from_match([lhs, rhs], tp_context)
       when is_constant(lhs) and not is_tuple(lhs) and not is_list(lhs) do
    rhs_typeset = get_typeset_from_segment(rhs, tp_context)
    lhs_typeset = get_typeset_from_segment(lhs, tp_context)

    typed_rhs = add_types_to_segment(rhs, rhs_typeset)
    typed_lhs = add_types_to_segment(lhs, lhs_typeset)

    typed_args = {typed_lhs, typed_rhs}

    {rhs_typeset, typed_args, tp_context}
  end

  # Top Case. If there are tuples or lists we have to solve them. Here we defer to lists.
  defp resolve_typeset_from_match([lhs, rhs], tp_context)
       when is_tuple(lhs) and is_tuple(rhs) do
    lhs = Tuple.to_list(lhs)
    rhs = Tuple.to_list(rhs)
    # If we ever try to get the type out of this, remember to remove the list type.
    # Even if this is a tuple, _rhs_typeset returns a list.
    {_rhs_typeset, {typed_lhs, typed_rhs}, tp_context} =
      resolve_typeset_from_match([lhs, rhs], tp_context)

    rhs_typeset = TypeSet.new(ElixirTypes.type_tuple())
    typed_lhs = List.to_tuple(typed_lhs)
    typed_rhs = List.to_tuple(typed_rhs)
    {rhs_typeset, {typed_lhs, typed_rhs}, tp_context}
  end

  # Top Case. If there are tuples or lists we have to solve them. Here we solve lists.
  defp resolve_typeset_from_match([lhs, rhs], tp_context)
       when is_list(lhs) and is_list(rhs) do
    match = Enum.zip(lhs, rhs)

    {typed_match, tp_context} =
      Enum.map_reduce(match, tp_context, fn e, acc ->
        # Elements are tuples thanks to .zip above
        {lhs, rhs} = e
        {_rhs_typeset, typed_match, tp_context} = resolve_typeset_from_match([lhs, rhs], acc)
        {typed_match, tp_context}
      end)

    {typed_lhs, typed_rhs} = Enum.unzip(typed_match)
    rhs_typeset = TypeSet.new(ElixirTypes.type_list())
    {rhs_typeset, {typed_lhs, typed_rhs}, tp_context}
  end
end

defmodule TPContext do
  alias Honey.TypeSet
  import Honey.Utils.Core, only: [is_var: 1, var_to_atom: 1]

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
