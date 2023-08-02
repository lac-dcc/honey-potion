defmodule Honey.EType.Float do
  defstruct []

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Integer, Float}

  defimpl Honey.EType do
    def op(_, :+, %module{}) when module in [Integer, Float] do
      %Float{}
    end

    def op(_, :-, %module{}) when module in [Integer, Float] do
      %Float{}
    end

    def op(_, :*, %module{}) when module in [Integer, Float] do
      %Float{}
    end

    def op(_, :/, %module{}) when module in [Integer, Float] do
      %Float{}
    end

    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def new() do
    %Float{}
  end
end
