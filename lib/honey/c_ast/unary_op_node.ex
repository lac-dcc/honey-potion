defmodule Honey.CAst.UnaryOperationNode do
  defstruct op: nil, arg: nil

  alias Honey.CAst
  alias Honey.CValue
  alias CAst.{OperationNode, UnaryOperationNode}

  defimpl CValue do
    def get_c_representation(_self, _options \\ []) do
      # TODO
      "UnaryOperationNode"
    end

    def get_type(self) do
      CValue.get_type(self.arg)
    end
  end

  defimpl OperationNode do
    def get_op(self) do
      self.op
    end
  end

  def new(op, arg) do
    %UnaryOperationNode{op: op, arg: arg}
  end
end
