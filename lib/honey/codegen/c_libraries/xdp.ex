defmodule Honey.XDP do
  alias Honey.Analysis.ElixirTypes

  def drop() do
    ElixirTypes.type_integer()
  end

  def pass() do
    ElixirTypes.type_integer()
  end
end
