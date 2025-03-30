defmodule Honey.Ethhdr do
  alias Honey.Analysis.ElixirTypes

  def init() do
    ElixirTypes.type_invalid()
  end

  def const_udp() do
    ElixirTypes.type_integer()
  end

  def ip_protocol() do
    ElixirTypes.type_integer()
  end

  def destination_port() do
    ElixirTypes.type_integer()
  end

  def set_destination_port(_dest_port) do
    ElixirTypes.type_integer()
  end

  def h_source() do
    ElixirTypes.type_void()
  end
end
