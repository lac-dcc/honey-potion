defmodule Honey.EType.Integer do
  defstruct []

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Integer, Float}

  defimpl Honey.EType do
    def op(_, :+, mod_type = %mod_name{}) when mod_name in [Integer, Float] do
      mod_type
    end

    def op(_, :-, mod_type = %mod_name{}) when mod_name in [Integer, Float] do
      mod_type
    end

    def op(_, :*, mod_type = %mod_name{}) when mod_name in [Integer, Float] do
      mod_type
    end

    def op(_, :/, %mod_name{}) when mod_name in [Integer, Float] do
      %Float{}
    end

    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def new() do
    %Integer{}
  end
end
