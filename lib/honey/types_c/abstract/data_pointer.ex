defmodule Honey.CType.DataPointer do
  defstruct data_access: nil, data_end_access: nil

  alias Honey.CType.{DataPointer}
  alias Honey.CValue
  alias Honey.CAst.Utils
  alias Honey.CType

  def op(:cast, pointer_expr, cast_type) do
    cast_type_def = CType.get_type_declaration_str(cast_type)
    my_type = CValue.get_type(pointer_expr)
    code = """
    if(#{my_type.data_access} + sizeof(#{cast_type_def}) >= #{my_type.data_access}) {
      return XDP_PASS;
    }
    """
    {cast_type, "(#{cast_type_def})#{my_type.data_access}", code}
  end

  def op(operator, _rep1, type) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CType do
    def get_type_declaration_str(_pointer) do
      raise "Context type of xdp_md does not allow type definition."
    end

    def op(_, operator, expr_pointer, param) do
      DataPointer.op(operator, expr_pointer, param)
    end

    def is_native?(_self) do
      false
    end
  end

  def new(data_access, data_end_access) do
    %DataPointer{data_access: data_access, data_end_access: data_end_access}
  end
end
