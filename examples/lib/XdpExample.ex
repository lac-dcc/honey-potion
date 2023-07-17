# IN PROGRESS

defmodule XdpExample do
  alias Honey.CExpr.CVariable
  alias Honey.StructType
  alias Honey.CNativeType
  alias ElixirSense.Providers.Suggestion.Reducers.Struct
  use Honey, license: "Dual BSD/GPL"
  defmap(
    :map,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 256}
  )

  def test_ints() do
    alias Honey.CExpr.{CConstant, Utils}
    alias Honey.CNativeType.{Int, Long}

    int_type = Int.new()
    long_type = Long.new()

    int_const5 = CConstant.new(int_type, "5")
    int_const6 = CConstant.new(int_type, "6")
    long_const7 = CConstant.new(long_type, "7")
    long_const8 = CConstant.new(long_type, "8")

    # Utils.op(:-, int_const5, int_const6)
    # |> dbg()

    # Utils.op(:+, long_const7, int_const6)
    # |> dbg()

    Utils.op(:+, int_const6, long_const7)
    |> dbg()

    # Utils.op(:+, long_const7, long_const8)
    # |> dbg()
  end

  def test_structs() do
    alias Honey.CExpr.{CVariable}
    alias Honey.CNativeType.{Int, Struct}

    int_type = Int.new()
    struct_type = Struct.new("my_struct", [f1: int_type, f2: int_type])
    var = CVariable.new("a_var", struct_type)

    CNativeType.op(struct_type, :access, var, :f3)
  end

  def test_array() do
    alias Honey.CExpr.{CVariable, CConstant}
    alias Honey.CNativeType.{Int, Struct, Array}

    int_type = Int.new()
    array_int_5 = Array.new(int_type, 5)
    int_const1 = CConstant.new(int_type, "1")
    var = CVariable.new("a_var", array_int_5)

    CNativeType.op(array_int_5, :access, var, int_const1)
    CNativeType.get_type_definition_str(array_int_5)
  end

  def test_pointer() do
    alias Honey.CExpr.{CVariable, CConstant}
    alias Honey.CNativeType.{Int, Struct, Pointer}

    int_type = Int.new()
    pointer_int = Pointer.new(int_type)
    int_const5 = CConstant.new(int_type, "5")
    var = CVariable.new("a_var", pointer_int)

    CNativeType.op(pointer_int, :dereference, var, nil)
    |> dbg()

    CNativeType.op(pointer_int, :+, var, int_const5)
    |> dbg()
  end

  @sec "xdp"
  def main(ctx) do
    x = cond do
      true ->
        1

      false ->
        5.0
    end
    a = 1
    b = 2
    c = a + b
    # eth = Honey.Helpers.parse_ethhdr(ctx.data)
    # src = eth.h_source

    # item = Honey.Bpf_helpers.bpf_map_lookup_elem(:map, 1)

    # count = cond do
    #   item ->
    #     item
    #   true ->
    #     true
    # end

    # Honey.Bpf_helpers.bpf_map_update_elem(:map, 1, count)

    # 2
  end
end
