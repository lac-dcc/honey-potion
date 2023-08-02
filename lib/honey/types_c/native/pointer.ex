defmodule Honey.CNativeType.Pointer do
  defstruct type: nil

  alias Honey.CValue
  alias Honey.CAst.Utils
  alias Honey.CType
  alias Honey.CNativeType.{Pointer, Integer}

  def op(:dereference, pointer_expr, _, _) do
    pointer_repr = CValue.get_c_representation(pointer_expr)
    pointer_type = CValue.get_type(pointer_expr)
    {pointer_type.type, "*(#{pointer_repr})"}
  end

  def op(:cast, pointer_expr, cast_type, _) do
    cast_type_def = CType.get_type_declaration_str(cast_type)
    pointer_repr = CValue.get_c_representation(pointer_expr)
    {cast_type, "(#{cast_type_def})#{pointer_repr}"}
  end

  def op(:+, pointer_expr, %Integer{}, expr) do
    expr_repr = CValue.get_c_representation(expr)
    pointer_repr = CValue.get_c_representation(pointer_expr)
    pointer_type = CValue.get_type(pointer_expr)
    {pointer_type, "(#{pointer_repr} + #{expr_repr})"}
  end

  def op(:assign = operator, pointer_expr, expr_type, expr) do
    expr_repr = CValue.get_c_representation(expr)
    pointer_repr = CValue.get_c_representation(pointer_expr)
    pointer_type = CValue.get_type(pointer_expr)

    # TODO: do something more idiomatic
    case expr_type do
      ^pointer_type ->
        nil

      %Integer{} ->
        nil

      _ ->
        Utils.operator_not_defined_error!(__MODULE__, operator, expr_type.__struct__)
    end

    {pointer_type, "#{pointer_repr} = #{expr_repr}"}
  end

  def op(:define, pointer_expr, expr_type, expr) do
    {type, code} = op(:assign, pointer_expr, expr_type, expr)
    type_dclr = CType.get_type_declaration_str(type)
    {type, "#{type_dclr} #{code}"}
  end

  def op(operator, _rep1, type, _rep2) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CType do
    alias Honey.CType

    def get_type_declaration_str(pointer) do
      type_str = CType.get_type_declaration_str(pointer.type)
      "#{type_str}*"
    end

    def op(_, operator, expr_pointer, expr) do
      expr_type = expr && CValue.get_type(expr)
      Pointer.op(operator, expr_pointer, expr_type, expr)
    end

    def is_native?(_self) do
      true
    end
  end

  def new(type) when is_struct(type) do
    Utils.assert_protocol!(type, CType)

    %Pointer{type: type}
  end
end
