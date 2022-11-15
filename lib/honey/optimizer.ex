defmodule Honey.Optimizer do
  alias Honey.{ConstantPropagation, DCE, Analyze}
  #Runs the optimization and analysis steps.
  def run(fun_def) do
    fun_def |> Analyze.run()
    |> ConstantPropagation.run()
    |> DCE.run()
  end
end
