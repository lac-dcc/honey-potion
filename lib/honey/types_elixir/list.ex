defmodule Honey.EType.List do
  defstruct size: :unknown, types: Keyword.new()

  alias Honey.EType
  alias Honey.CAst.Utils
  alias EType.{List}

  defimpl Honey.EType do
    def op(_, :++, mod_type = %mod_name{}) when mod_name in [Integer, Float] do
      raise "TODO"
    end

    def op(_, :--, mod_type = %mod_name{}) when mod_name in [Integer, Float] do
      raise "TODO"
    end

    def op(_, operator, type2) do
      Utils.operator_not_defined_error!(__MODULE__, operator, type2.__struct__)
    end
  end

  def insert_at(list, index, type) do
    raise "TODO"
  end

  def delete_at(list, index) do
    raise "TODO"
  end

  def replace_at(list, index) do
    raise "TODO"
  end

  def new() do
    %List{}
  end
end
