defprotocol Honey.CAst do
  def to_str(ast)
end

defprotocol Honey.CAst.OperationNode do
  def get_op(ast)
end

defmodule Honey.CAst.Utils do
  alias Honey.CType
  alias Honey.CValue
  alias Honey.CValue.{CConstant}

  def is_constant(%CConstant{}) do
    true
  end

  def is_constant(_) do
    false
  end

  def assert_protocol!(var, protocol) when is_struct(var) and is_atom(protocol) do
    try do
      Protocol.assert_impl!(protocol, var.__struct__)
    rescue
      ArgumentError ->
        raise "Module #{var.__struct__} does not implement protocol #{protocol}."
    end
  end

  def assert_protocol(var, protocol) when is_struct(var) and is_atom(protocol) do
    try do
      Protocol.assert_impl!(protocol, var.__struct__)
      true
    rescue
      ArgumentError ->
        false
    end
  end

  def op(operator, value) when is_atom(operator) and is_struct(value) do
    assert_protocol!(value, CValue)

    type = CValue.get_type(value)
    CType.op(type, operator, value, nil)
  end

  def op(operator, value1, value2) when is_atom(operator) and is_struct(value1) do
    assert_protocol!(value1, CValue)

    type1 = CValue.get_type(value1)
    CType.op(type1, operator, value1, value2)
  end

  def check_type(value, type) do
    assert_protocol!(type, CType)

    CValue.get_type(value) == type
  end

  def operator_not_defined_error!(type1, operator, type2) do
    raise "Type #{type1} does not implement the operator '#{operator}' for type #{type2}"
  end

  def indent(str, level \\ 1) do
    if(level < 0) do
      raise "The level passed to #{__MODULE__}.indent/2 must be greater or equal to 0."
    end

    level = level - 1

    tab = "\t"
    level_str = Enum.reduce(0..level//1, "", fn _, acc ->
      acc <> tab
    end)

    str
    |> String.split("\n")
    |> Enum.map(fn line ->
      line = String.trim_leading(line, " ")
      level_str <> line
    end)
    |> Enum.join("\n")
  end
end
