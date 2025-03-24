defmodule CountSysCalls do
  use Honey, license: "Dual BSD/GPL"

  printlist = [{"Syscall: enter_read (0) | Qtt:", 0}, {"Syscall: enter_write (1) | Qtt:", 1},
  {"SysCall: enter_kill (62) | Qtt:", 62}, {"SysCall: enter_mkdir (83) | Qtt:", 83},
  {"SysCall: enter_getrandom (318) | Qtt:", 318}] # Defines the {"Name", key} of each printed element
  
  # Defines a map with BPF_MAP_TYPE_ARRAY type, 335 entries and the above printlist
  defmap(:Count_Sys_Calls_Invoked, :bpf_array, [max_entries: 335, print: true, print_elem: printlist])

  @sec "tracepoint/raw_syscalls/sys_enter" # Sets our trigger to sys_enter
  def main(ctx) do
    id = ctx.id # Grabs the ID of the sys_enter, which represents what sys_enter call was done

    id_count = Honey.BpfHelpers.bpf_map_lookup_elem(:Count_Sys_Calls_Invoked, id) # Grabs the old value in the map
    Honey.BpfHelpers.bpf_map_update_elem(:Count_Sys_Calls_Invoked, id, id_count + 1) # and increments it by one
  end
end
