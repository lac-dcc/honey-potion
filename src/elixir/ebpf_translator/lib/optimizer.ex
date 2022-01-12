defmodule Optimizer do
  def run(fun_def) do
    fun_def
    |> ConstantPropagation.run()
    |> DCE.run()
  end
end
