defmodule Honey.CNativeType.Struct do
  defstruct name: "", fields: []

  alias Honey.CExpr
  alias Honey.CExpr.{Utils, CVariable}
  alias Honey.CNativeType.Struct

  defimpl Honey.CNativeType do
    def get_type_definition_str(struct) do
      "struct #{struct.name}"
    end

    def op(_, :access, value, field)
        when is_struct(value) and is_atom(field) do
      struct = CExpr.get_type(value)

      if(Keyword.fetch(struct.fields, field) == :error) do
        # concat_fields = Enum.join(struct.fields, "\", \"")

        raise "'struct #{struct.name}' does not contain the field #{field}. Available fields are: [\"#{""}\"]"
      end

      repr = CExpr.get_c_representation(value)
      "#{repr}.#{field}"
    end

    def op(_, operator, _value, value2) do
      type = CExpr.get_type(value2)
      Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
    end
  end

  def new(name, fields) when is_bitstring(name) and is_list(fields) do
    # TODO: Should check a few more things about these fields
    if(!Keyword.keyword?(fields)) do
      raise "Second parameter to #{__MODULE__}.new/2 should be a Keyword List."
    end

    %Struct{name: name, fields: fields}
  end
end
