defmodule Honey.CNativeType.Struct do
  defstruct name: "", fields: []

  alias Honey.CValue
  alias Honey.CAst.Utils
  alias Honey.CNativeType.Struct

  defimpl Honey.CType do
    def get_type_declaration_str(struct) do
      "struct #{struct.name}"
    end

    def op(_, :access, value, field)
        when is_struct(value) and is_atom(field) do
      struct = CValue.get_type(value)

      field_type =
        case Keyword.fetch(struct.fields, field) do
          :error ->
            concat_fields =
              struct.fields
              |> Enum.map(fn {field, _type} ->
                Atom.to_string(field)
              end)
              |> Enum.join(", :")

            raise "'struct #{struct.name}' does not contain the field #{field}. Available fields are: [:#{concat_fields}]"

          {:ok, type} ->
            type
        end

      repr = CValue.get_c_representation(value)
      {field_type, "#{repr}.#{field}"}
    end

    def op(_, operator, _value, value2) do
      type = CValue.get_type(value2)
      Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
    end

    def is_native?(_self) do
      true
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
