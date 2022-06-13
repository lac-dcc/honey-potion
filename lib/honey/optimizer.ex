defmodule Honey.Optimizer do
  alias Honey.{ConstantPropagation, DCE}

  def run(fun_def) do
    fun_def
    |> ConstantPropagation.run()
    |> DCE.run()
  end
end
