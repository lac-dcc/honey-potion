defmodule Honey.CNativeType.Pointer do
  defstruct type: nil

  alias Honey.CExpr
  alias Honey.CExpr.Utils
  alias Honey.CNativeType
  alias Honey.CNativeType.{Pointer, Int}

  def op(:dereference, pointer_expr, _, _) do
    pointer_repr = CExpr.get_c_representation(pointer_expr)
    pointer_type = CExpr.get_type(pointer_expr)
    {pointer_type.type, "*(#{pointer_repr})"}
  end

  def op(:cast, pointer_expr, cast_type, _) do
    cast_type_def = CNativeType.get_type_definition_str(cast_type)
    pointer_repr = CExpr.get_c_representation(pointer_expr)
    {cast_type, "(#{cast_type_def})#{pointer_repr}"}
  end

  def op(:+, pointer_expr, %Int{}, expr) do
    expr_repr = CExpr.get_c_representation(expr)
    pointer_repr = CExpr.get_c_representation(pointer_expr)
    pointer_type = CExpr.get_type(pointer_expr)
    {pointer_type, "(#{pointer_repr} + #{expr_repr})"}
  end

  def op(operator, _rep1, type, _rep2, _) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CNativeType do
    alias Honey.CNativeType

    def get_type_definition_str(pointer) do
      type_pointer = pointer.type

      type_str = CNativeType.get_type_definition_str(type_pointer)
      {"#{type_str}", "[#{pointer.size}]"}
    end

    def op(_, operator, expr_pointer, expr) do
      expr_type = expr && CExpr.get_type(expr)
      Pointer.op(operator, expr_pointer, expr_type, expr)
    end
  end

  def new(type) when is_struct(type) do
    Utils.check_protocol(type, CNativeType)

    %Pointer{type: type}
  end
end
