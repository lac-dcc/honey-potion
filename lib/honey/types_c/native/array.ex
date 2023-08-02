defmodule Honey.CNativeType.Array do
  defstruct type: nil, size: 0

  alias Honey.CValue
  alias Honey.CAst.Utils
  alias Honey.CType
  alias Honey.CNativeType.{Array, Integer}

  def op(:access, rep_1, %Integer{}, index_repr, array) do
    {CValue.get_type(array), "(#{rep_1})[#{index_repr}]"}
  end

  def op(operator, _rep1, type, _rep2, _) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CType do
    alias Honey.CType

    def get_type_declaration_str(array) do
      type_array = array.type

      type_str = CType.get_type_declaration_str(type_array)
      {"#{type_str}", "[#{array.size}]"}
    end

    def op(_, operator, array, index) do
      repr1 = CValue.get_c_representation(array)
      repr2 = CValue.get_c_representation(index)
      type2 = CValue.get_type(index)

      Array.op(operator, repr1, type2, repr2, array)
    end

    def is_native?(_self) do
      true
    end
  end

  def new(type, size) when is_struct(type) and is_integer(size) do
    Utils.assert_protocol!(type, CType)

    %Array{type: type, size: size}
  end
end
