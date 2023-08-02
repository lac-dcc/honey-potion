defprotocol Honey.EValue do
  def get_type(value)
end

defprotocol Honey.EType do
  def op(type, operator, type2)
end

defmodule Honey.EValue.EConstant do
  defstruct type: nil, ast: nil

  require Honey.Utils
  alias Honey.CAst
  alias Honey.EValue.{EConstant}
  alias Honey.EType

  def new(type, ast) when is_struct(type) and Honey.Utils.is_constant(ast) do
    CAst.Utils.assert_protocol!(type, EType)

    %EConstant{type: type, ast: ast}
  end

  defimpl Honey.EValue do
    def get_type(const = %EConstant{}) do
      const.type
    end
  end
end

defmodule Honey.EValue.EVariable do
  defstruct name: "", type: nil

  alias Honey.CAst.Utils
  alias Honey.EValue.{EVariable}
  alias Honey.EType

  defimpl Honey.EValue do
    def get_type(var) do
      var.type
    end
  end

  def new(name, type) when is_bitstring(name) and is_struct(type) do
    Utils.assert_protocol!(type, EType)
    %EVariable{name: name, type: type}
  end

  def is_variable(var) when is_struct(var) do
    var.__struct__ == __MODULE__
  end
end

defmodule Honey.EType.Utils do
  alias Honey.CAst
  alias Honey.EValue
  alias Honey.EType

  def op(operator, value1, value2) do
    CAst.Utils.assert_protocol!(value1, EValue)

    type1 = EValue.get_type(value1)
    type2 = EValue.get_type(value2)
    EType.op(type1, operator, type2)
  end
end
