defmodule Honey.Analyze do
  def run(ast) do
    #Does a postwalk to count how many uses for each variable. First element of tuple is ignored.
    {_,lvu} = Macro.postwalk(ast, [] , fn segment, lvu ->
      if match?({_, [version: _, line: _], nil}, segment) do
        {var, [version: _, line: _], nil} = segment
        {_,lvu} = Keyword.get_and_update(lvu, var, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)
        {:ok, lvu}
      else
        {:none, lvu}
      end
    end)

    IO.inspect(lvu)

    #Does a second postwalk to recount, if the new count reached the first one, that's the last use.
    Macro.postwalk(ast, [] , fn segment, nlvu ->
      if match?({_, [version: _, line: _], nil}, segment) do
        {var, [version: _, line: l], nil} = segment
        {_,nlvu} = Keyword.get_and_update(nlvu, var, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)
        if(Keyword.get(nlvu, var) == Keyword.get(lvu, var)) do
          IO.puts("Variable " <> to_string(var) <> " was last used in line " <> to_string(l))
        end
        {:ok, nlvu}
      else
        {:none, nlvu}
      end
    end)

  end
end
