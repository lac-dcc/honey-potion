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
    # Currently IO.inspect is bugged and can't print typed AST's properly. Use this to debug instead.
    fun_def
    |> IO.inspect([limit: :infinity, pretty: :true])
    |> ConstantPropagation.run()
    |> DeadCodeElimination.run()
    |> StaticAnalysis.run()
    |> TreeSplit.run()
    |> IO.inspect([limit: :infinity, pretty: :true])

    # Use this to execute code.
    fun_def
    #|> IO.inspect([limit: :infinity, pretty: :true])
    |> ConstantPropagation.run()
    |> DeadCodeElimination.run()
    |> StaticAnalysis.run()
    |> TypePropagation.run(arguments, env)

    # |> Honey.Analysis.AstSize.output(env, " - Final")
    #|> IO.inspect()
    |> TreeSplit.run()
    #|> IO.inspect([limit: :infinity, pretty: :true])
  end
end
