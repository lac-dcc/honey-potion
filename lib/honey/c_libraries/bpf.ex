defmodule Honey.Bpf_helpers do
  alias Honey.ElixirType

  def bpf_printk(_str) do
    ElixirType.type_integer()
  end

  def bpf_get_current_pid_tgid() do
    ElixirType.type_integer()
  end

  def bpf_map_lookup_elem(_map, _key) do
  end

  def bpf_map_update_elem(_map, _key, _value, _flags) do
  end

  def bpf_map_update_elem(_map, _key, _value) do
  end
end
