defmodule Honey.CNativeType.Integer do
  defstruct bit_size: 0, unsigned?: false
  alias Honey.CType
  alias Honey.CValue
  alias Honey.CAst.Utils
  alias Honey.CNativeType.{Integer}

  def op(:+, _type1, repr1, _type2, repr2, biggest_type) do
    {biggest_type, "#{repr1} + #{repr2}"}
  end

  def op(:define, _type1, repr1, _type2, repr2, biggest_type) do
    type_dclr = CType.get_type_declaration_str(biggest_type)
    {biggest_type, "#{type_dclr} #{repr1} = #{repr2}"}
  end

  def op(operator, _, _, type, _, _) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CNumericType do
    def get_bit_size(type) do
      type.bit_size
    end

    def unsigned?(type) do
      type.unsigned?
    end
  end

  defimpl Honey.CType do
    def get_type_declaration_str(type) do
      unsigned_str =
        if(type.unsigned?) do
          "u"
        else
          "s"
        end

      "__#{unsigned_str}#{type.bit_size}"
    end

    def op(_, operator, value1, value2) do
      type1 = CValue.get_type(value1)
      type2 = CValue.get_type(value2)

      if(!Utils.assert_protocol(type2, Honey.CType)) do
          Utils.operator_not_defined_error!(@for, operator, type2.__struct__)
      end

      if(type1.unsigned? != type2.unsigned?) do
        raise "Tried to operate a signed number with unsigned number."
      end

      biggest_type =
        if(type1.bit_size >= type2.bit_size) do
          type1
        else
          type2
        end

      repr1 = CValue.get_c_representation(value1)
      repr2 = CValue.get_c_representation(value2)

      Integer.op(operator, type1, repr1, type2, repr2, biggest_type)
    end

    def is_native?(_self) do
      true
    end
  end

  def new(bit_size, unsigned? \\ false) when is_integer(bit_size) and is_boolean(unsigned?) do
    available_sizes = [8, 16, 32, 64]
    if(bit_size not in available_sizes) do
      raise "Invalid bit_size, should be one of [8, 16, 32, 64]."
    end

    %Integer{bit_size: bit_size, unsigned?: unsigned?}
  end
end
