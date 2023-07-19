defmodule ExampleTest do
  use ExUnit.Case

  alias Honey.CValue
  alias Honey.CType
  alias Honey.CNativeType
  alias CType.{Ctx_xdp_md}
  alias CType.Structs.{Sys_enter}
  alias CValue.{CVariable, CConstant, Utils}
  alias CNativeType.{Array, Integer, Long, Pointer, Struct}

  test "Test Integer type" do
    s8_type = Integer.new(8)
    s16_type = Integer.new(16)
    s32_type = Integer.new(32)
    s64_type = Integer.new(64)

    s16_const3 = CConstant.new(s32_type, "3")
    s16_const4 = CConstant.new(s32_type, "4")
    s32_const5 = CConstant.new(s32_type, "5")
    s32_const6 = CConstant.new(s32_type, "6")
    s64_const7 = CConstant.new(s64_type, "7")
    s64_const8 = CConstant.new(s64_type, "8")

    # Utils.op(:-, s32_const5, s32_const6)
    # |> dbg()

    {type, code} = Utils.op(:+, s64_const7, s32_const6)
    assert {type, code} == {%Honey.CNativeType.Integer{bit_size: 64, unsigned?: false}, "7 + 6"}

    assert CType.get_type_declaration_str(type) == "__s64"

    assert Utils.op(:+, s32_const6, s64_const7) ==
             {%Honey.CNativeType.Integer{bit_size: 64, unsigned?: false}, "6 + 7"}

    assert =
      Utils.op(:+, s64_const7, s64_const8) ==
        {%Honey.CNativeType.Integer{bit_size: 64, unsigned?: false}, "7 + 8"}
  end

  test "Test Structs type" do
    int_type = Integer.new(32)
    struct_type = Struct.new("my_struct", f1: int_type, f2: int_type)
    var = CVariable.new("a_var", struct_type)

    # TODO: Test a case where we access a wrong field
    assert CType.op(struct_type, :access, var, :f2) ==
             {%Honey.CNativeType.Integer{bit_size: 32, unsigned?: false}, "a_var.f2"}
  end

  test "Test Array type" do
    int_type = Integer.new(32)
    array_int_5 = Array.new(int_type, 5)
    int_const1 = CConstant.new(int_type, "1")
    var = CVariable.new("a_var", array_int_5)

    assert CType.op(array_int_5, :access, var, int_const1) ==
             {%Honey.CNativeType.Array{
                type: %Honey.CNativeType.Integer{bit_size: 32, unsigned?: false},
                size: 5
              }, "(a_var)[1]"}

    assert CType.get_type_declaration_str(array_int_5) == {"__s32", "[5]"}
  end

  test "Test Pointer type" do
    int_type = Integer.new(32)
    pointer_int = Pointer.new(int_type)
    int_const5 = CConstant.new(int_type, "5")
    var = CVariable.new("a_var", pointer_int)

    assert CType.op(pointer_int, :dereference, var, nil) ==
             {%Honey.CNativeType.Integer{bit_size: 32, unsigned?: false}, "*(a_var)"}

    assert CType.op(pointer_int, :+, var, int_const5) ==
             {%Honey.CNativeType.Pointer{
                type: %Honey.CNativeType.Integer{bit_size: 32, unsigned?: false}
              }, "(a_var + 5)"}
  end

  test "Test Ctx_xdp_md type" do
    int_type = Integer.new(32)
    pointer_int_type = Pointer.new(int_type)

    ctx = Ctx_xdp_md.new()
    var = CVariable.new("ctx", ctx)

    {datapointer_type, code} = Utils.op(:access, var, :data)

    assert {datapointer_type, code} ==
             {%Honey.CType.DataPointer{
                data_access: "ctx->data",
                data_end_access: "ctx->data_end"
              }, "ctx->data"}

    var2 = CVariable.new("data", datapointer_type)

    assert var2 == %Honey.CValue.CVariable{
             name: "data",
             type: %Honey.CType.DataPointer{
               data_access: "ctx->data",
               data_end_access: "ctx->data_end"
             }
           }

    assert Utils.op(:cast, var2, pointer_int_type) ==
             {%Honey.CNativeType.Pointer{
                type: %Honey.CNativeType.Integer{bit_size: 32, unsigned?: false}
              }, "(__s32*)ctx->data",
              "if(ctx->data + sizeof(__s32*) >= ctx->data) {\n  return XDP_PASS;\n}\n"}
  end

  test "Test Ctx_sys_enter type" do
    ctx = Sys_enter.new()
    var = CVariable.new("ctx", ctx)

    assert Utils.op(:access, var, :id) == {%Honey.CNativeType.Integer{bit_size: 32, unsigned?: false}, "ctx.id"}
  end
end
