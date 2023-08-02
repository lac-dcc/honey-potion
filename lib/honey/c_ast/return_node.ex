defmodule Honey.CAst.ReturnNode do
  defstruct value: nil

  alias Honey.CAst
  alias Honey.CValue
  alias CAst.{ReturnNode}

  defimpl CValue do
    def get_c_representation(self, _options \\ []) do
      value_c = CValue.get_c_representation(self.value)
      "return #{value_c}"
    end

    def get_type(self) do
      CValue.get_type(self.value)
    end
  end

  def new(value) do
    %ReturnNode{value: value}
  end
end
