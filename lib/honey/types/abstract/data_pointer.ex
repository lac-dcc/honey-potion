defmodule Honey.CType.DataPointer do
  defstruct data_access: nil, data_end_access: nil

  alias Honey.CType.{Ctx_xdp_md, DataPointer, Structs.Xdp_md}
  alias Honey.CExpr
  alias Honey.CExpr.Utils
  alias Honey.CType
  alias Honey.CNativeType.{Pointer, Int}

  def op(:cast, pointer_expr, cast_type) do
    cast_type_def = CType.get_type_definition_str(cast_type)
    my_type = CExpr.get_type(pointer_expr)
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
    alias Honey.CType

    def get_type_definition_str(pointer) do
      raise "Context type of xdp_md does not allow type definition."
    end

    def op(_, operator, expr_pointer, param) do
      DataPointer.op(operator, expr_pointer, param)
    end
  end

  def new(data_access, data_end_access) do
    %DataPointer{data_access: data_access, data_end_access: data_end_access}
  end
end
