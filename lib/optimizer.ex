defmodule Honey.Optimizer do
  def run(fun_def) do
    fun_def
    |> Honey.ConstantPropagation.run()
    |> Honey.DCE.run()
  end
end
