defmodule Honey.CNativeType.Array do
  defstruct type: nil, size: 0

  alias Honey.CExpr
  alias Honey.CExpr.Utils
  alias Honey.CNativeType
  alias Honey.CNativeType.{Array, Int}

  def op(:access, rep_1, %Int{}, index_repr, array) do
    {CExpr.get_type(array), "(#{rep_1})[#{index_repr}]"}
  end

  def op(operator, _rep1, type, _rep2, _) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CNativeType do
  alias Honey.CNativeType
    def get_type_definition_str(array) do
      type_array = array.type

      type_str = CNativeType.get_type_definition_str(type_array)
      {"#{type_str}", "[#{array.size}]"}
    end

    def op(_, operator, array, index) do
      repr1 = CExpr.get_c_representation(array)
      repr2 = CExpr.get_c_representation(index)
      type2 = CExpr.get_type(index)

      Array.op(operator, repr1, type2, repr2, array)
    end
  end

  def new(type, size) when is_struct(type) and is_integer(size) do
    Utils.check_protocol(type, CNativeType)

    %Array{type: type, size: size}
  end
end
