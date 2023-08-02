defmodule Honey.Test.ElixirTypes do
  use ExUnit.Case

  alias Honey.EValue
  alias Honey.EType
  alias EValue.{EVariable, EConstant}
  alias EType.{Integer, Float}

  test "Test Elixir Integer type" do
    int_type = Integer.new()
    float_type = Float.new()

    var1 = EVariable.new("var1", int_type)
    var2 = EVariable.new("var2", int_type)
    var3 = EVariable.new("var2", float_type)
    const5 = EConstant.new(float_type, 5)

    EType.Utils.op(:+, var1, var2)
    |> dbg()

    EType.Utils.op(:+, var2, var3)
    |> dbg()

    EType.Utils.op(:+, var1, const5)
    |> dbg()
  end
end
