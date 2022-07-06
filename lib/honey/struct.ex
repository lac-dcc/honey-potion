defmodule Honey.Struct do
  defstruct [:name, :fields]

  def new(name, fields \\ []) do
    %Honey.Struct{name: name, fields: fields}
  end

  def add_field(struct, new_field) do
    put_in(struct.fields, [new_field | struct.fields])
  end

  def to_c_type(struct) do
    "ElixirStruct_" <> struct.name
  end

  def field_to_c_field!(struct, field) do
    if(Enum.member?(struct.fields, field)) do
      "idx_" <> field
    else
      raise "(field_to_c_field!): Tried to access field '#{field}' from struct '#{struct.name}', but it does not exist."
    end
  end

  def field_to_id!(struct, field) do
    if(Enum.member?(struct.fields, field)) do
      "field_id_" <> field
    else
      raise "(field_to_id!): Tried to access field '#{field}' from struct '#{struct.name}', but it does not exist."
    end
  end

  def to_type_enum(struct) do
    "TYPE_" <> struct.name
  end

  def to_ElixirValue_accessor(struct) do
    "value_#{struct.name}"
  end
end
