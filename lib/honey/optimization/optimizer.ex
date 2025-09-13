defmodule Honey.Optimization.Optimizer do
  @moduledoc """
  Module to define and run the optimization pipeline that runs over elixirs AST.
  """
  alias Honey.Analysis.DotGraph
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
    # Modifying optimizations
    |> ConstantPropagation.run()
    |> DeadCodeElimination.run()
    |> TreeSplit.run()
    # Analysis optimizations
    |> StaticAnalysis.run()
    |> TypePropagation.run(arguments, env)
    # Debugging and info optimizations
    |> DotGraph.variable_interference_graph(env)
    #|> Honey.Analysis.AstSize.output(env, " - Final")
  end
end
