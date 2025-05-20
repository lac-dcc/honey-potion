defmodule Honey.Optimization.TreeSplit do
  def run(ast) do
    Macro.prewalk(ast, &split_conditionals/1)
  end

  def split_conditionals({:__block__, metadata, instructions}) do
    # Accumulator = {Previous, Split, Tree}
    {previous, split, tree} = 
      Enum.reduce(instructions, {[], nil, []}, fn x, acc ->
        {previous, split, tree} = acc
        if split == nil do
          if match?({:case, _, _}, x) || match?({:cond, _, _}, x) do
            {previous, x, tree}
          else
            {[x | previous], split, tree}
          end
        else
          {previous, split, [x| tree]}
        end
      end)
    if split == nil do
      {:__block__, metadata, instructions}
    else
      # Split the code into before_condition, condition (split) and after_condition.
      {previous, split, tree} = {Enum.reverse(previous), split, Enum.reverse(tree)}

      split_tree = if tree == [] do
        split
      else 
        # Join the condition and after_condition 
        {cond_type, metadata, conditions} = split
        conditions = case cond_type do
          :cond -> 
            [[do: conditions_list]] = conditions
            #IO.inspect(conditions_list)
            conditions_list = Enum.map(conditions_list, fn x ->
              {arrow, metadata, [boolcond, resultcond]} = x
              {arrow, metadata, [boolcond, {:__block__, [], [resultcond] ++ tree}]}
            end)
            #IO.inspect("Here lol")
            #IO.inspect(conditions_list)
          [[do: conditions_list]]
          :case -> 
            [match_var, [do: conditions_list]] = conditions
            conditions_list = Enum.map(conditions_list, fn x ->
              {arrow, metadata, [boolcond, resultcond]} = x
              {arrow, metadata, [boolcond, {:__block__, [], [resultcond] ++ tree}]}
            end)
          [match_var, [do: conditions_list]]
        end
        {cond_type, metadata, conditions}
      end

      # Concatenate previous with condition
      if previous == [] do
        split_tree
      else
        {:__block__, metadata, previous ++ [split_tree]}
      end
    end
  end

  def split_conditionals(ast) do
    ast
  end
end
