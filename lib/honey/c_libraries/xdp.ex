defmodule Honey.XDP do
  alias Honey.ElixirType

  def drop() do
    ElixirType.type_integer()
  end

  def pass() do
    ElixirType.type_integer()
  end
end
