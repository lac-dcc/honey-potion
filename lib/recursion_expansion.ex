# This alpha version contains some limitations:
# - Fuel can only be used inside main/1
# - The function called inside fuel:
#     - Cannot have guards
#     - Cannot destructure its arguments
#     - Cannot have default arguments
#     - Must be in the same module as main/1
# - It doesn't expand mutual recursions yet

defmodule Honey.Fuel do
  defmacro fuel(ammount, fun_call) do
    ensure_caller(__CALLER__)

    {module, function, arity, _args} = decompose_call!(fun_call, __CALLER__)

    fun_call = add_fuel_metadata(fun_call, ammount)

    fun_call
  end

  defp ensure_caller(env) do
    case env.function do
      {fun, arity} ->
        if(fun != :main or arity != 1) do
          Honey.Utils.compile_error!(env, "fuel can only be called inside main/1")
        end

      _ ->
        Honey.Utils.compile_error!(env, "fuel can only be called inside main/1")
    end
  end

  # Currently it only accepts calls from the same module

  def burn_fuel(main_ast, env) do
    {new_ast, modified} =
      Macro.postwalk(main_ast, false, fn segment, modified ->
        case segment do
          {_fun_name, meta, _args} ->
            if fuel = Keyword.get(meta, :fuel) do
              if(fuel > 0) do
                new_ast = get_def_for_reinjection(segment, env, fuel)
                {new_ast, true}
              else
                new_segment =
                  quote do
                    raise "Provide more fuel!"
                  end

                {new_segment, true}
              end
            else
              {segment, modified}
            end

          _ ->
            {segment, modified}
        end
      end)

    if(modified) do
      burn_fuel(new_ast, env)
    else
      new_ast
    end
  end

  def get_def_for_reinjection(fun_call, env, current_fuel) do
    {module, function, arity, actual_args} = decompose_call!(fun_call, env)
    fun_def = Module.get_definition(module, {function, arity})

    {:v1, _kind, _metadata, [clause | _other_clauses]} = fun_def
    {_metadata, formal_args, _guards, func_ast} = clause

    context = String.to_atom("Fuel#{current_fuel}")

    formal_into_actual =
      for {formal_arg, i} <- Enum.with_index(formal_args) do
        actual_arg = Enum.at(actual_args, i)
        {arg_name, arg_meta, _} = formal_arg
        # var = Macro.var(arg_name, context)
        var = {arg_name, arg_meta, context}

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
              {module_, function_, arity_, _} = decompose_call!(segment, env)

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

  defp replace_context(ast, new_context) do
    Macro.postwalk(ast, fn segment ->
      case segment do
        {var_name, meta, context} ->
          if(is_atom(var_name) and is_atom(context)) do
            {var_name, meta, new_context}
          else
            segment
          end

        _ ->
          segment
      end
    end)
  end

  defp add_fuel_metadata({fun_name, meta, args}, fuel)
       when is_atom(fun_name) and is_list(meta) and is_list(args) do
    {fun_name, Keyword.put(meta, :fuel, fuel), args}
  end

  defp decompose_call!({fun_name, meta, args}, caller_env)
       when is_atom(fun_name) and is_list(meta) and is_list(args) do
    {caller_env.module, fun_name, length(args), args}
  end

  defp decompose_call!(call, caller_env) do
    err_msg =
      "second argument of fuel must be a call to the same module, got: #{Macro.to_string(call)}"

    case call do
      {{:., _, [{:__aliases__, _, modules}, fun_name]}, _, args} ->
        module =
          Enum.reduce(modules, "Elixir", fn mod, mods ->
            mods <> "." <> Atom.to_string(mod)
          end)
          |> String.trim(".")
          |> String.to_atom()

        {module, fun_name, length(args), args}

      _ ->
        Honey.Utils.compile_error!(
          caller_env,
          err_msg
        )
    end
  end
end
