defmodule Honey.EType.Binary do
  defstruct size: :unknown, types: Keyword.new()

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Binary}

  defimpl Honey.EType do
    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def append(binary, index) do
    raise "TODO"
  end

  def new() do
    %Binary{}
  end
end
