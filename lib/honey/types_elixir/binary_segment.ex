defmodule Honey.EType.BinarySegment do
  defstruct value: nil, seg_type: nil, unit: nil, size: nil, signed: false, endian: :big

  alias Honey.EValue
  alias EValue.EConstant
  alias EValue.EVariable
  alias Honey.EType
  alias EType.{Atom, Binary, Float, Integer, List, Struct, Tuple}
  alias EType.BinarySegment
  alias Honey.CAst.Utils

  defp normalize_value_type(value) do
    cond do
      Utils.check_type(value, Honey.EType.Integer) ->
        :integer

      Utils.check_type(value, Honey.EType.Float) ->
        :float

      Utils.check_type(value, Honey.EType.Binary) ->
        :binary

      true ->
        # TODO: This problem should generate a runtime error, not a compile-time one.
        type = EValue.get_type(value)
        raise "value passed to #{__MODULE__}.new was of type #{type}"
    end
  end

  defp get_seg_type_from_type(%Float{}) do
    :float
  end

  defp get_seg_type_from_type(%Integer{}) do
    :integer
  end

  defp get_seg_type_from_type(%Binary{}) do
    :binary
  end

  defp get_seg_type_from_type(_) do
    :invalid
  end

  defp normalize_seg_type(seg_type, value_type) do
    possible_types = [
      nil,
      :integer,
      :float,
      # :bitstring,
      # :bits, # alias for bitstring
      :binary,
      :bytes #alias for binary
      # :utf8,
      # :utf16,
      # :utf32
    ]

    possible_types_str =
      possible_types
      |> Macro.escape()
      |> Macro.to_string()

    if(seg_type not in possible_types) do
      # TODO: Improve this error message. It seems to be equivalent to the error: "unknown bitstring specifier: ..." when
      # you do <<1::wrong_type>>, for instance.
      raise "seg_type passed to #{BinarySegment}.new must be one of #{possible_types_str}"
    end

    # bits is an alias for bitstring
    # bytes is an alias for binary
    seg_type =
      case seg_type do
        :bits ->
          :bitstring

        :bytes ->
          :binary

        other ->
          other
      end

    # seg_type = case value do
    #   %EConstant{} ->
    #     value_type = EValue.get_type(value)
    #     value_seg_type = get_seg_type_from_type(value_type)
    #     cond do
    #       seg_type === nil ->
    #         value_seg_type

    #       seg_type === value_seg_type ->
    #         value_seg_type

    #         # ...
    #     end


    #   %EVariable{} ->
    #     nil

    #   _ ->
    #     raise "Invalid value passed to #{__MODULE__}.new"
    # end
  end

  defp normalize_endian(endian) do
    possible_types = [:big, :little]

    if(endian not in possible_types) do
      raise "endian passed to #{BinarySegment}.new must be one of [:big, :little]"
    end
  end

  def new(value, seg_type \\ nil, unit \\ nil, size \\ nil, signed \\ nil, endian \\ nil) do
    value_type = normalize_value_type(value)
    seg_type = normalize_seg_type(seg_type, value_type)
    normalize_endian(endian)

    %BinarySegment{
      value: value,
      seg_type: seg_type,
      unit: unit,
      size: size,
      signed: signed,
      endian: endian
    }
  end
end
