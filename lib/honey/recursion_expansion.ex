defmodule Honey.Fuel do
  import Honey.Utils, only: [is_var: 1, is_call: 1, compile_error!: 2]

  @moduledoc """
  Manages Fuel for function calls.
  In Honey-Potion, Fuel is the ammount of recursive calls that a function call can generate.
  When set to a Fixed value it guarantees a non-looping program, a prerequisite for eBPF programs.

  This alpha version contains some limitations:
  - Fuel can only be used inside main/1
  - The function called inside fuel:
      - Cannot have guards
      - Cannot destructure its arguments
      - Cannot have default arguments
      - Must be in the same module as main/1
  - It doesn't expand mutual recursions yet
  """

  @doc """
  Defines the macro fuel which adds the fuel ammount into the metadata of a function call.
  """

  defmacro fuel(amount, fun_call) do
    ensure_caller(__CALLER__)

    add_fuel_metadata(fun_call, amount)
  end

  defp transform_function_matching_to_case_do({name, arity}, env) do
    {:v1, _kind, _metadata, clauses} = Module.get_definition(env.module, {name, arity})
    do_expressions = Enum.map(clauses, fn clause ->
      # TODO: Add support for guards
        {_metadata, formal_args, _guards, func_ast} = clause
        [formal_args, func_ast]
      end)
      do_expressions
    # {_metadata, formal_args, _guards, func_ast} = clause
    # clauses
  end

  defp get_function_key({name, arity}), do: get_function_key(name, arity)

  defp get_function_key(name, arity) do
    "#{name}.#{to_string(arity)}"
  end


  defp functions_to_case_do(env) do
    function_names_and_arity = Module.definitions_in(env.module)
    function_keys = Enum.map(function_names_and_arity, &get_function_key/1)
    function_declarations = Enum.map(function_names_and_arity, fn current_function -> transform_function_matching_to_case_do(current_function, env) end)


    Enum.zip([function_keys, function_declarations])
    |> Map.new()
  end

  defp get_case_block_for_function({function_name, function_arity}, function_arguments, function_declarations_map),
    do: get_case_block_for_function(function_name, function_arity, function_arguments, function_declarations_map)

  defp get_case_block_for_function(function_name, function_arity, function_arguments, function_declarations_map) do
    function_key = get_function_key(function_name, function_arity)
    function_declarations = function_declarations_map[function_key]
    {:case, [], [
      function_arguments,
      [
        do: Enum.map(function_declarations, fn function_case -> {:->, [], function_case} end)
      ]

    ]}
  end

  @doc """
  Burns fuel with consecultive passes through the AST until no more changes are made.
  Currently it only accepts calls from the same module.
  """

  def burn_fuel(main_ast, env) do
    function_declarations_map = functions_to_case_do(env)
    # IO.inspect(function_declarations_map)
    IO.inspect(get_case_block_for_function("foo", 1, [3],function_declarations_map))

    {new_ast, modified} =
      Macro.postwalk(main_ast, false, fn
        {_, meta, _} = call, modified when is_call(call) ->
          case Keyword.get(meta, :fuel) do
            fuel when is_integer(fuel) and fuel > 0 ->
              new_ast = get_def_for_reinjection(call, env, fuel)

              {new_ast, true}

            fuel when is_integer(fuel) ->
              {quote(do: raise("Provide more fuel!")), true}

            _ ->
              {call, modified}
          end

        ast, modified ->
          {ast, modified}
      end)

    if modified do
      burn_fuel(new_ast, env)
    else
      new_ast
    end
  end

  #Makes sure fuel is used inside the main function.
  defp ensure_caller(%Macro.Env{function: {:main, 1}}), do: :ok

  defp ensure_caller(env) do
    compile_error!(env, "fuel can only be called inside main/1")
  end

  @doc """
  Unrolls one fuel of a specific function call and subtracts the value of its fuel by one.
  """

  def get_def_for_reinjection(fun_call, env, current_fuel) do
    {module, function, arity, actual_args} = decompose_call(fun_call, env)
    fun_def = Module.get_definition(module, {function, arity})

    {:v1, _kind, _metadata, [clause | _other_clauses]} = fun_def
    {_metadata, formal_args, _guards, func_ast} = clause

    context = String.to_atom("Fuel#{current_fuel}")

    formal_into_actual =
      for {formal_arg, actual_arg} <- Enum.zip(formal_args, actual_args) do
        var = replace_context(formal_arg, context)

        quote do
          unquote(var) = unquote(actual_arg)
        end
      end

    ast_with_context = replace_context(func_ast, context)

    ast_with_args =
      quote do
        # IO.puts("Burned the #{unquote(current_fuel)}th fuel")
        unquote_splicing(formal_into_actual)
        unquote(ast_with_context)
      end

    # Add fuel to the calls
    final_ast =
      Macro.postwalk(ast_with_args, fn segment ->
        case segment do
          {var_name, _meta, args} ->
            if(is_atom(var_name) and is_list(args)) do
              {module_, function_, arity_, _} = decompose_call(segment, env)

              if(module_ == module and function_ == function and arity_ == arity) do
                add_fuel_metadata(segment, current_fuel - 1)
              else
                segment
              end
            else
              segment
            end

          _ ->
            segment
        end
      end)

    final_ast
  end

  #Walks the AST replacing the old context (Third element of variables) with the new_context.
  defp replace_context(ast, new_context) do
    Macro.postwalk(ast, fn
      {name, meta, _ctx} = var when is_var(var) ->
        {name, meta, new_context}

      other ->
        other
    end)
  end

  #Gives or updates the fuel of a function call into the metadata of the call.
  defp add_fuel_metadata(call, fuel) when is_call(call) do
    Macro.update_meta(call, &[{:fuel, fuel} | &1])
  end

  #Transforms a function call into parameters that we need.
  defp decompose_call(call, caller_env) do
    case call do
      {fun_name, _meta, args} = call when is_call(call) ->
        {caller_env.module, fun_name, length(args), args}

      {{:., _, [{:__aliases__, _, modules}, fun_name]}, _, args} ->
        {Module.concat(modules), fun_name, length(args), args}

      _ ->
        compile_error!(
          caller_env,
          "second argument of fuel must be a call to the same module, got: #{Macro.to_string(call)}"
        )
    end
  end
end
