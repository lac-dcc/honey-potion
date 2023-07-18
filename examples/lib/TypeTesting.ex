# IN PROGRESS

defmodule TypeTesting do
  alias Honey.CExpr
  alias Honey.CType
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
    alias Honey.CType
    alias Honey.CExpr.{CVariable}
    alias Honey.CNativeType.{Int, Struct}

    int_type = Int.new()
    struct_type = Struct.new("my_struct", [f1: int_type, f2: int_type])
    var = CVariable.new("a_var", struct_type)

    CType.op(struct_type, :access, var, :f3)
  end

  def test_array() do
    alias Honey.CType
    alias Honey.CExpr.{CVariable, CConstant}
    alias Honey.CNativeType.{Int, Array}

    int_type = Int.new()
    array_int_5 = Array.new(int_type, 5)
    int_const1 = CConstant.new(int_type, "1")
    var = CVariable.new("a_var", array_int_5)

    CType.op(array_int_5, :access, var, int_const1)
    CType.get_type_definition_str(array_int_5)
  end

  def test_pointer() do
    alias Honey.CType
    alias Honey.CExpr.{CVariable, CConstant}
    alias Honey.CNativeType.{Int, Pointer}

    int_type = Int.new()
    pointer_int = Pointer.new(int_type)
    int_const5 = CConstant.new(int_type, "5")
    var = CVariable.new("a_var", pointer_int)

    CType.op(pointer_int, :dereference, var, nil)
    |> dbg()

    CType.op(pointer_int, :+, var, int_const5)
    |> dbg()
  end

  def ctx_xdp_md() do
    alias Honey.CType.{Ctx_xdp_md}
    alias Honey.CExpr.{CVariable, Utils}
    alias Honey.CNativeType.{Int, Pointer}

    int_type = Int.new()
    pointer_int_type = Pointer.new(int_type)

    ctx = Ctx_xdp_md.new()
    var = CVariable.new("ctx", ctx)

    {datapointer_type, _code} = Utils.op(:access, var, :data)
    var2 = CVariable.new("data", datapointer_type)
    Utils.op(:cast, var2, pointer_int_type)
  end

  def ctx_sys_enter() do
    alias Honey.CType.Structs.{Sys_enter}
    alias Honey.CExpr.{CVariable, Utils}

    ctx = Sys_enter.new()
    var = CVariable.new("ctx", ctx)

    Utils.op(:access, var, :id)
    |> dbg()
  end

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(ctx) do

  end
end
