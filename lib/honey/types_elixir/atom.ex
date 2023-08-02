defmodule Honey.EType.Atom do
  defstruct []

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{Atom}

  defimpl Honey.EType do
    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def new() do
    %Atom{}
  end
end
