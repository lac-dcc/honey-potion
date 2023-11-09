defmodule Honey.Optimizer do
  alias Honey.{ConstantPropagation, DCE, Analyze, TypePropagation}

  @moduledoc """
  Module to define and run the optimization pipeline that runs over elixirs AST.
  """

  @doc """
  Runs the optimization and analysis steps.
  """

  def run(fun_def, arguments, env) do
    fun_def |> Analyze.run()
    |> AstSize.output(env, " - Start")
    |> ConstantPropagation.run()
    |> AstSize.output(env, " - CP")
    |> DCE.run()
    |> AstSize.output(env, " - DCE")
    |> TypePropagation.run(arguments, env)
    |> AstSize.output(env, " - Final")
    #|> IO.inspect()
  end
end
