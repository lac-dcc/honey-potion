defmodule Honey.Analyze do

  @moduledoc """
  Runs analysis on the elixir AST. Currently does liveness, last use, scope and reusable variables analysis.
  """

  @doc """
  Runs the analysis given an elixir AST.
  """

  def run(ast) do
    import Honey.Utils, only: [is_var: 1]

    #Does a postwalk to count how many uses for each variable. First element of tuple is ignored.
    #lvu == List of Variable Uses
    {_,lvu} = Macro.postwalk(ast, [] , fn segment, lvu ->
      if is_var(segment) do
        #Get info from segment
        {var, meta, context} = segment
        ver = Keyword.get(meta, :version)

        #Transform info to unique key
        keystring = to_string(var) <> "_" <> to_string(ver) <> "_" <> to_string(context)
        keyatom = String.to_atom(keystring)

        #Keep key and number of uses in Keyword
        {_,lvu} = Keyword.get_and_update(lvu, keyatom, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)
        {:ok, lvu}
      else
        {:none, lvu}
      end
    end)

    #Does a second postwalk to recount, if the new count reached the first one, that's the last use.
    {ast, _} = Macro.postwalk(ast, [] , fn segment, nlvu ->
      if is_var(segment) do
        #Get info from segment
        {var, meta, context} = segment
        ver = Keyword.get(meta, :version)

        #Transform info to unique key
        keystring = to_string(var) <> "_" <> to_string(ver) <> "_" <> to_string(context)
        keyatom = String.to_atom(keystring)

        #Keep key and number of uses in Keyword
        {_,nlvu} = Keyword.get_and_update(nlvu, keyatom, fn x -> if is_integer(x), do: {x, x + 1}, else: {nil, 1} end)

        #Confirm if this use is the last use. Adds :last accordingly [true or false].
        if(Keyword.get(nlvu, keyatom) == Keyword.get(lvu, keyatom)) do
          segment = {var, Keyword.put(meta, :last, true), context}

          {segment, nlvu}
        else
          segment = {var, Keyword.put(meta, :last, false), context}

          {segment, nlvu}
        end

      else
        {segment, nlvu}
      end
    end)

    ast

  end
end
