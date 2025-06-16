defmodule Honey.BpfHelpers do
  @moduledoc """
  This module provides helper functions for interacting with eBPF maps and system calls.

  The functions in this module act as placeholders for BPF helper functions that are commonly
  used in eBPF programs. Each function returns a value of type `integer`, which is the typical
  return type of eBPF helper functions.

  ## Functions

    * `bpf_printk/1` - Simulates a call to `bpf_printk`, used for debugging in eBPF programs.
    * `bpf_get_current_pid_tgid/0` - Retrieves the current process ID (PID) and thread group ID (TGID).
    * `bpf_ktime_get_ns/0` - Retrieves the current time in nanoseconds.
    * `bpf_map_lookup_elem/2` - Simulates looking up an element in an eBPF map.
    * `bpf_map_lookup_elem/3` - Simulates looking up an element in an eBPF map, with a default value.
    * `bpf_map_update_elem/3` - Simulates updating an element in an eBPF map.
    * `bpf_map_update_elem/4` - Simulates updating an element in an eBPF map with flags.

  These functions serve as stubs that will be replaced with actual eBPF calls or compiled into
  lower-level BPF instructions.
  """
  import Honey.Analysis.ElixirTypes, only: [type_integer: 0]

  def bpf_printk(_str), do: type_integer()

  def bpf_get_current_pid_tgid(), do: type_integer()

  def bpf_ktime_get_ns(), do: type_integer()

  def bpf_map_lookup_elem(_map, _key), do: type_integer()

  def bpf_map_lookup_elem(_map, _key, _default_value), do: type_integer()

  def bpf_map_update_elem(_map, _key, _value, _flags), do: type_integer()

  def bpf_map_update_elem(_map, _key, _value), do: type_integer()
end
