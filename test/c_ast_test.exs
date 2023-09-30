defmodule Honey.Test.CAst do
  use ExUnit.Case

  alias Honey.CValue
  alias Honey.CType
  alias Honey.CNativeType
  alias Honey.CAst
  alias CType.{Ctx_xdp_md}
  alias CValue.{CVariable, CConstant}
  alias CNativeType.{Integer, Pointer}
  alias CAst.{BinaryOperationNode, BlockNode, IfNode, ReturnNode}

  def print_code(code) do
    """

    --------------- Code ----------------------

    #{code}

    --------------- End of Code ---------------

    """
    |> IO.puts()
  end

  test "Test C Ast" do
    ctx_xdp_type = Ctx_xdp_md.new()
    u32 = Integer.new(32, true)
    p_u32 = Pointer.new(u32)

    var1 = CVariable.new("var1", u32)
    var2 = CVariable.new("var2", p_u32)
    _ctx = CVariable.new("var3", ctx_xdp_type)

    const0 = CConstant.new(u32, "0")
    const7 = CConstant.new(u32, "7")
    const9 = CConstant.new(u32, "9")

    if_block = BlockNode.new()
    |> BlockNode.add_node(const7)
    |> BlockNode.add_node(const7)
    |> BlockNode.add_node(const7)
    else_block = BlockNode.new()
    |> BlockNode.add_node(const9)
    if_node = IfNode.new(const0, if_block, else_block)

    var1_def_node = BinaryOperationNode.new(:define, var1, if_node)
    var2_def_node = BinaryOperationNode.new(:define, var2, var1)

    return_node = ReturnNode.new(var1)

    BlockNode.new()
    |> BlockNode.add_node(var1_def_node)
    |> BlockNode.add_node(var2_def_node)
    |> BlockNode.add_node(return_node)
    |> Honey.CValue.get_c_representation()
    |> print_code()
  end
end
