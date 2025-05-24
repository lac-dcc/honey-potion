defmodule Honey.Optimization.Optimizer do
  @moduledoc """
  Module to define and run the optimization pipeline that runs over elixirs AST.
  """
  alias Honey.Analysis.StaticAnalysis
  alias Honey.Optimization.ConstantPropagation
  alias Honey.Optimization.DeadCodeElimination
  alias Honey.Optimization.TypePropagation
  alias Honey.Optimization.TreeSplit

  @doc """
  Runs the optimization and analysis steps.
  """
  def run(fun_def, arguments, env) do
    fun_def
    |> StaticAnalysis.run()
    |> ConstantPropagation.run()
    |> DeadCodeElimination.run()
    |> TypePropagation.run(arguments, env)

    # |> Honey.Analysis.AstSize.output(env, " - Final")
    #|> IO.inspect()
    |> TreeSplit.run()
    #|> IO.inspect()
  end
end
