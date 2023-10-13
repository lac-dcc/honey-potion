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
    |> ConstantPropagation.run()
    |> DCE.run()
    |> TypePropagation.run(arguments, env)
    # |> IO.inspect()
  end
end
