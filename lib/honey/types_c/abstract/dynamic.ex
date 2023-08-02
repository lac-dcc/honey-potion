defmodule Honey.CType.Dynamic do
  defstruct types: nil

  alias Honey.CType
  alias Honey.CValue
  alias Honey.CAst.Utils
  alias CType.{Dynamic}

  defimpl Honey.CType do
    def get_type_declaration_str(_struct) do
      "struct xdp_md*"
    end

    # def op(_, :access, value, field)
    #     when is_struct(value) and is_atom(field) do
    #   case field do
    #     :data ->
    #       repr = CValue.get_c_representation(value)

    #       data_pointer_type = DataPointer.new("#{repr}->data", "#{repr}->data_end")
    #       {data_pointer_type, "#{repr}->#{field}"}

    #     _ ->
    #       raise "The context type of xdp_md cannot access this field. The only allowed is 'data'."
    #   end
    # end

    def op(_, operator, _value, value2) do
      type = CValue.get_type(value2)
      Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
    end

    def is_native?(_self) do
      false
    end
  end

  def add_type(self, type) do
    %Dynamic{self | types: self.types ++ type}
  end

  def new() do
    %Dynamic{}
  end
end
