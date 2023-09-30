defmodule Honey.EType.BinarySegment do
  defstruct value: nil, seg_type: nil, unit: nil, size: nil, signed: false, endian: :big

  alias Honey.EValue
  alias EValue.EConstant
  alias EValue.EVariable
  alias Honey.EType
  alias EType.{Atom, Binary, Float, Integer, List, Struct, Tuple}
  alias EType.BinarySegment
  alias Honey.CAst.Utils

  defp get_value_type(value) do
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

  defp get_seg_type_from_type(type) do
    raise "Currently, you cannot use a value of type #{type.__struct__} inside a binary."
  end

  defp normalize_seg_type(seg_type) do
    possible_types = [
      :integer,
      :float,
      # :bitstring,
      # :bits is an alias for bitstring
      # :bits,
      :binary,
      # :bytes is an alias for binary
      :bytes
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
      # you do <<1::invalid_type>>, for instance.
      raise "seg_type passed to #{BinarySegment}.new must be one of #{possible_types_str}"
    end

    # bits is an alias for bitstring
    # bytes is an alias for binary
    case seg_type do
      :bits ->
        :bitstring

      :bytes ->
        :binary

      other ->
        other
    end
  end

  defp get_seg_type(value, options) do
    value_type = get_value_type(value)
    case Keyword.fetch(options, :seg_type) do
      {:ok, seg_type} ->
        seg_type = normalize_seg_type(seg_type)

        if(value_type != seg_type) do
          case value do
            %EConstant{} ->
              # This shouldn't even be possible, shoud it?. As of my understanding, the Elixir compiler would get this error before we do.
              raise "The type of the value passed to #{__MODULE__}.new is #{value_type}, but the seg_type passed is #{seg_type}. They should be the same."

            %EVariable{} ->
              # TODO: This should be a runtime error.
              raise "The type of the value passed to #{__MODULE__}.new is #{value_type}, but the seg_type passed is #{seg_type}. They should be the same."

            _ ->
              raise "Invalid value passed to #{__MODULE__}.new"
          end
        end

        seg_type

      :error ->
        value_type
    end
  end

  defp get_endian(options) do
    possible_endians = [:big, :little]

    case Keyword.fetch(options, :endian) do
      {:ok, endian} ->
        if(endian not in possible_endians) do
          raise "endian passed to #{BinarySegment}.new must be one of [:big, :little]"
        end

        endian

      :error ->
        :big
    end
  end

  defp get_unit(seg_type, options) do
    case Keyword.fetch(options, :unit) do
      {:ok, unit} ->
        if(!is_integer(unit)) do
          raise "Option :unit passed to #{__MODULE__}.new must be an integer."
        end

        unit

      :error ->
        case seg_type do
          :integer ->
            1

          :float ->
            1

          :binary ->
            8

          :unknown ->
            :unknown
        end
    end
  end

  defp get_size(seg_type, options) do
    case Keyword.fetch(options, :size) do
      {:ok, size} ->
        if(!is_integer(size)) do
          raise "Option :size passed to #{__MODULE__}.new must be an integer."
        end

        size

      :error ->
        case seg_type do
          :integer ->
            8

          :float ->
            64

          :binary ->
            # TODO: Get the size of the binary
            :unknown

          :unknown ->
            :unknown
        end
    end
  end

  defp get_signed(seg_type, options) do
    case Keyword.fetch(options, :signed) do
      {:ok, signed} ->
        if(!is_boolean(signed)) do
          raise "Option :signed passed to #{__MODULE__}.new must be a boolean."
        end

        case seg_type do
          :integer ->
            signed

          :unknown ->
            :unknown

          _ ->
            raise "Option :signed can only be passed to #{__MODULE__}.new if the type of the segment is integer."
        end

      :error ->
        case seg_type do
          :integer ->
            false

          _ ->
            :unknown
        end
    end
  end

  defp check_validity(seg_type, unit, size) when is_integer(unit) and is_integer(size) do
    # TODO: Possibly, those should be runtime errors
    bits = unit * size

    if(rem(bits, 8) != 0) do
      raise "Binaries must have a total number of bits divisible by 8. Got unit=#{unit} and size=#{size}, resulting in #{bits} bits."
    end

    if(seg_type == :float and bits != 32 and bits != 64) do
      raise "Honey demands floats of 32 or 64 bits. Got unit=#{unit} and size=#{size}, resulting in #{bits} bits."
    end
  end

  defp check_validity(_, _, _) do
    :ok
  end

  @doc """
  Available options are:
  - seg_type
  - unit
  - size
  - signed
  - endian
  """
  def new(value, options \\ []) do
    defaults = [unit: :unknwon, size: :unknwon, signed: :unknwon, endian: :unknwon]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    seg_type = get_seg_type(value, options)
    unit = get_unit(seg_type, options)
    size = get_size(seg_type, options)
    signed = get_signed(seg_type, options)
    endian = get_endian(options)

    check_validity(seg_type, unit, size)

    %BinarySegment{value: value, seg_type: seg_type, unit: unit, size: size, signed: signed, endian: endian}
  end
end
