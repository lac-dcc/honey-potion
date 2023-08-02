defmodule Honey.CAst.BinaryOperationNode do
  defstruct op: nil, arg1: nil, arg2: nil

  alias Honey.CAst
  alias Honey.CValue
  alias CAst.{OperationNode, BinaryOperationNode, Utils}

  defimpl CValue do
    def get_c_representation(self, _options \\ []) do
      {_type, code} = Utils.op(self.op, self.arg1, self.arg2)
      code
    end

    def get_type(self) do
      {type, _} = Utils.op(self.op, self.arg1, self.arg2)
      type
    end
  end

  defimpl OperationNode do
    def get_op(self) do
      self.op
    end
  end

  def new(op, arg1, arg2) do
    %BinaryOperationNode{op: op, arg1: arg1, arg2: arg2}
  end
end
