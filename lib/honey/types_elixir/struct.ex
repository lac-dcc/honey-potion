defmodule Honey.EType.Struct do
  defstruct fields: Keyword.new()

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Struct}

  defimpl Honey.EType do
    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def access(struct, value) do
    raise "TODO"
  end

  def new(fields) do
    %Struct{fields: fields}
  end
end
