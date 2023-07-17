defprotocol Honey.CExpr do
  @spec get_c_representation(t) :: bitstring
  def get_c_representation(value)

  def get_type(value)
end

defprotocol Honey.CNativeType do

  def get_type_definition_str(type)

  def op(type, operator, value1, value2)
end

defmodule Honey.CExpr.CConstant do
  defstruct c_type: nil, c_code: ""

  alias Honey.CExpr.{CConstant, Utils}
  alias Honey.CNativeType

  def new(type, code) when is_struct(type) and is_bitstring(code) do
    Utils.check_protocol(type, CNativeType)

    %CConstant{c_type: type, c_code: code}
  end

  defimpl Honey.CExpr do
    def get_c_representation(const = %CConstant{}) do
      const.c_code
    end

    def get_type(const = %CConstant{}) do
      const.c_type
    end
  end
end

defmodule Honey.CExpr.CVariable do
  defstruct name: "", type: nil

  alias Honey.CExpr.{CVariable, Utils}
  alias Honey.CNativeType

  defimpl Honey.CExpr do
    def get_c_representation(var) do
      var.name
    end

    def get_type(var) do
      var.type
    end
  end

  def new(name, type) when is_bitstring(name) and is_struct(type) do
    Utils.check_protocol(type, CNativeType)
    %CVariable{name: name, type: type}
  end

  def is_variable(var) when is_struct(var) do
    var.__struct__ == __MODULE__
  end

end

defmodule Honey.CExpr.Utils do
  alias Honey.CNativeType
  alias Honey.CExpr
  alias Honey.CExpr.{CConstant}

  def is_constant(c = %CConstant{}) do
    true
  end

  def is_constant(_) do
    false
  end

  def check_protocol(var, protocol) when is_struct(var) and is_atom(protocol) do
    Protocol.assert_impl!(protocol, var.__struct__)
  end

  def op(operator, value1, value2) when is_atom(operator) and is_struct(value1) and is_struct(value2) do
    check_protocol(value1, CExpr)
    check_protocol(value2, CExpr)

    type1 = CExpr.get_type(value1)
    CNativeType.op(type1, operator, value1, value2)
  end

  def check_type(value, type) do
    check_protocol(type, CNativeType)

    CExpr.get_type(value) == type
  end

  def operator_not_defined_error!(type1, operator, type2) do
    raise "Type #{type1} does not implement the operator '#{operator}' for type #{type2}"
  end
end
