defmodule Honey.Analysis.AstSize do
  @moduledoc """
  This module measures the size of the Elixir AST.
  """
  alias Honey.Utils.Core

  @doc """
  Outputs the size of the AST.
  Usage: output(AST, environment, optional<suffix_to_size>)
  """
  def output(ast, env, step \\ "") do
    {_, size} = Macro.postwalk(ast, 0, fn seg, acc -> {seg, 1 + acc} end)
    IO.puts(Core.module_name(env) <> " - " <> Integer.to_string(size) <> step)
    ast
  end
end
