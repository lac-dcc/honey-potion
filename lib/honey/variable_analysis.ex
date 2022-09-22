defmodule Honey.Analyze do
  def run(ast) do
    import Honey.Utils, only: [is_var: 1]
    #Does a postwalk to count how many uses for each variable. First element of tuple is ignored.
    #lvu == List of Variable Uses
    {_,lvu} = Macro.postwalk(ast, [] , fn segment, lvu ->
      if is_var(segment) do
        var = elem(segment, 0)
        {_,lvu} = Keyword.get_and_update(lvu, var, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)
        {:ok, lvu}
      else
        {:none, lvu}
      end
    end)

    #Does a second postwalk to recount, if the new count reached the first one, that's the last use.
    {ast, _} = Macro.postwalk(ast, [] , fn segment, nlvu ->
      if is_var(segment) do
        var = elem(segment, 0)
        meta = elem(segment, 1)
        context = elem(segment, 2)
        {_,nlvu} = Keyword.get_and_update(nlvu, var, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)
        if(Keyword.get(nlvu, var) == Keyword.get(lvu, var)) do
          #Prints the variable and the line of the last use:: #IO.puts("Variable " <> to_string(var) <> " was last used in line " <> to_string(l))
          segment = {var, meta ++ [{:last, true}], context}
          {segment, nlvu}
        else
          segment = {var, meta ++ [{:last, false}], context}

          {segment, nlvu}
        end

      else
        {segment, nlvu}
      end
    end)

    ast

  end
end
