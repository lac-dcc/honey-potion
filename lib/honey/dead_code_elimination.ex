defmodule Honey.DCE do
  import Honey.Utils, only: [is_var: 1, is_constant: 1]

  def get_uses(segment, uses \\ []) do
    cond do
      is_constant(segment) ->
        uses

      is_var(segment) ->
        [get_var_version(segment) | uses]

      true ->
        case segment do
          {{:., _, [:erlang, :+]}, _, [lhs, rhs]} ->
            new_uses = get_uses(lhs, uses)
            get_uses(rhs, new_uses)

          {{:., _, [:erlang, :-]}, _, [lhs, rhs]} ->
            new_uses = get_uses(lhs, uses)
            get_uses(rhs, new_uses)

          {{:., _, [:erlang, :*]}, _, [lhs, rhs]} ->
            new_uses = get_uses(lhs, uses)
            get_uses(rhs, new_uses)

          {{:., _, [:erlang, :/]}, _, [lhs, rhs]} ->
            new_uses = get_uses(lhs, uses)
            get_uses(rhs, new_uses)

          {{:., _, [:erlang, :==]}, _, [lhs, rhs]} ->
            new_uses = get_uses(lhs, uses)
            get_uses(rhs, new_uses)

          {:__block__, _meta, block_insts} ->
            return_statement = Enum.at(block_insts, -1)
            get_uses(return_statement, uses)

          _ ->
            uses
        end
    end
  end

  def check_params(_, def_use) do
    def_use
  end

  defp get_var_version(var) do
    {var_name, meta, context} = var
    String.to_atom(Atom.to_string(var_name) <> to_string(meta[:version]) <> to_string(context))
  end

  def eliminate_constants_in_code(block) do
    [return | reversed_block] = Enum.reverse(block)

    new_block = [return]

    new_block =
      Enum.reduce(reversed_block, new_block, fn segment, new_block_acc ->
        if is_constant(segment) do
          new_block_acc
        else
          [segment | new_block_acc]
        end
      end)

    new_block
  end

  def expand_blocks(block_insts) do
    reversed_block_insts = Enum.reverse(block_insts)

    new_block_insts =
      Enum.reduce(reversed_block_insts, [], fn segment, new_block_insts_acc ->
        case segment do
          {:__block__, _meta, block_insts} ->
            block_insts ++ new_block_insts_acc

          _ ->
            [segment | new_block_insts_acc]
        end
      end)

    new_block_insts =
      if(new_block_insts != block_insts) do
        expand_blocks(new_block_insts)
      else
        new_block_insts
      end

    new_block_insts
  end

  def analyze_case(case_block) do
    {:case, _, [var | [[do: cases]]]} = case_block

    if is_constant(var) do
      correct_block =
        Enum.find_value(cases, {false, nil}, fn a_case ->
          {:->, _meta, [[match], block]} = a_case

          if var == match do
            {true, block}
          end
        end)

      case correct_block do
        {true, block} ->
          block

        {false, _} ->
          case_block
      end
    else
      case_block
    end
  end

  def analyze_cond(cond_block) do
    {:cond, meta, [[do: conds]]} = cond_block

    {single_block?, new_conds_or_block} =
      Enum.reduce(conds, {false, []}, fn a_cond, opt_conds_pair ->
        {single_block?, new_conds} = opt_conds_pair

        if(single_block?) do
          opt_conds_pair
        else
          {:->, _meta, [[condition], block]} = a_cond

          cond do
            condition == true ->
              if(length(new_conds) == 0) do
                {true, block}
              else
                {false, [a_cond | new_conds]}
              end

            condition != false ->
              {false, [a_cond | new_conds]}

            condition == false ->
              opt_conds_pair
          end
        end
      end)

    if(single_block?) do
      new_conds_or_block
    else
      new_conds = Enum.reverse(new_conds_or_block)
      {:cond, meta, [[do: new_conds]]}
    end
  end

  def run(fun_def) do
    new_ast =
      Macro.prewalk(fun_def, fn segment ->
        case segment do
          {:case, _, _} ->
            analyze_case(segment)

          {:cond, _, _} ->
            analyze_cond(segment)

          _ ->
            segment
        end
      end)

    new_ast =
      Macro.prewalk(new_ast, fn segment ->
        case segment do
          {:__block__, meta, block} ->
            new_block = eliminate_constants_in_code(block)
            {:__block__, meta, new_block}

          _ ->
            segment
        end
      end)

    new_ast =
      Macro.prewalk(new_ast, fn segment ->
        case segment do
          {:__block__, meta, block} ->
            new_block = expand_blocks(block)
            {:__block__, meta, new_block}

          _ ->
            segment
        end
      end)

    {new_ast, _def_use} =
      Macro.prewalk(new_ast, Keyword.new(), fn segment, def_use ->
        {segment, def_use} =
          case segment do
            {:=, _meta, [lhs, rhs]} ->
              var_version = get_var_version(lhs)

              var_uses = get_uses(rhs)

              def_use =
                Keyword.update(def_use, var_version, [], fn uses ->
                  uses ++ var_uses
                end)

              {segment, def_use}

            {fun_name, meta, args} ->
              if(is_atom(fun_name) and is_list(meta) and is_list(args)) do
                function_uses =
                  Enum.reduce(args, [], fn arg, uses ->
                    get_uses(arg) ++ uses
                  end)

                def_use =
                  if(Enum.count(function_uses) > 0) do
                    Keyword.update(def_use, :function_call, [], fn uses ->
                      uses ++ function_uses
                    end)
                  else
                    def_use
                  end

                {segment, def_use}
              else
                {segment, def_use}
              end

            _ ->
              {segment, def_use}
          end

        {segment, def_use}
      end)

    # IO.puts("Uses:")
    # IO.inspect(def_use)

    # IO.puts("Ast after Dead Code Elimination:")
    # IO.inspect(new_ast)
    # IO.puts("\nCode after Dead Code Elimination:")
    # IO.puts(Macro.to_string(new_ast))

    new_ast
  end
end
