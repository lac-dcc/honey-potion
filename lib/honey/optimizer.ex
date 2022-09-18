defmodule Honey.Optimizer do
  alias Honey.{ConstantPropagation, DCE, Analyze}

  def run(fun_def) do
    Analyze.run(fun_def)
    fun_def
    |> ConstantPropagation.run()
    |> DCE.run()
  end
end
