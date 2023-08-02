defprotocol Honey.CValue do
  def get_c_representation(value, options \\ [])

  def get_type(value)
end

defprotocol Honey.CType do
  def get_type_declaration_str(type)

  def op(type, operator, value1, value2)

  def is_native?(type)
end

defprotocol Honey.CNumericType do
  def get_bit_size(type)
  def unsigned?(type)
end

defmodule Honey.CValue.CConstant do
  defstruct c_type: nil, c_code: ""

  alias Honey.CAst.Utils
  alias Honey.CValue.{CConstant}
  alias Honey.CType

  def new(type, code) when is_struct(type) and is_bitstring(code) do
    Utils.assert_protocol!(type, CType)

    %CConstant{c_type: type, c_code: code}
  end

  defimpl Honey.CValue do
    def get_c_representation(const = %CConstant{}, _options \\ []) do
      const.c_code
    end

    def get_type(const = %CConstant{}) do
      const.c_type
    end
  end
end

defmodule Honey.CValue.CVariable do
  defstruct name: "", type: nil

  alias Honey.CAst.Utils
  alias Honey.CValue.{CVariable}
  alias Honey.CType

  defimpl Honey.CValue do
    def get_c_representation(var, _options) do
      var.name
    end

    def get_type(var) do
      var.type
    end
  end

  def new(name, type) when is_bitstring(name) and is_struct(type) do
    Utils.assert_protocol!(type, CType)
    %CVariable{name: name, type: type}
  end

  def is_variable(var) when is_struct(var) do
    var.__struct__ == __MODULE__
  end
end
