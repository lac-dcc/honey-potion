defmodule Honey.CType.Structs.Xdp_md do
  def new() do
    alias Honey.CType
    alias Honey.CExpr.{CVariable}
    alias Honey.CNativeType.{Int, Struct}

    int_type = Int.new()

    fields = [
      data: int_type,
      data_end: int_type,
      data_meta: int_type,
      ingress_ifindex: int_type,
      rx_queue_index: int_type
    ]

    Struct.new("xdp_md", fields)
  end
end


defmodule Honey.CType.Ctx_xdp_md do
  defstruct xdp_md_pointer: nil

  alias Honey.CType.{Ctx_xdp_md, DataPointer, Structs.Xdp_md}
  alias Honey.CExpr
  alias Honey.CExpr.Utils
  alias Honey.CType
  alias Honey.CNativeType.{Pointer, Int}

  defimpl Honey.CType do
    def get_type_definition_str(struct) do
      "struct xdp_md*"
    end

    def op(_, :access, value, field)
        when is_struct(value) and is_atom(field) do
      case field do
        :data ->
          repr = CExpr.get_c_representation(value)

          data_pointer_type = DataPointer.new("#{repr}->data", "#{repr}->data_end")
          {data_pointer_type, "#{repr}->#{field}"}

        _ ->
          raise "The context type of xdp_md cannot access this field. The only allowed is 'data'."
      end
    end

    def op(_, operator, _value, value2) do
      type = CExpr.get_type(value2)
      Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
    end
  end

  def new() do
    struct_xdp_md = Xdp_md.new()
    xdp_md_pointer = Pointer.new(struct_xdp_md)
    %Ctx_xdp_md{xdp_md_pointer: xdp_md_pointer}
  end
end
