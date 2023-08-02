defmodule Honey.EType.Tuple do
  defstruct size: :unknown, types: Keyword.new()

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Tuple}

  defimpl Honey.EType do
    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def insert_at(tuple, index, type) do
    raise "TODO"
  end

  def delete_at(tuple, index) do
    raise "TODO"
  end

  def append(tuple, index) do
    raise "TODO"
  end

  def new() do
    %Tuple{}
  end
end
