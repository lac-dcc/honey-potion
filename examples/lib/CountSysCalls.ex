defmodule CountSysCalls do
  use Honey, license: "Dual BSD/GPL"
  
  # This module is meant to follow the CountSysCalls benchmark.
  # It counts the system calls under sys_enter and prints it every second.
  # To add more system calls to the print list just add them to the variable below!

  printlist = [{"Syscall: enter_read (0) | Qtt:", 0}, {"Syscall: enter_write (1) | Qtt:", 1},
  {"SysCall: enter_kill (62) | Qtt:", 62}, {"SysCall: enter_mkdir (83) | Qtt:", 83},
  {"SysCall: enter_getrandom (318) | Qtt:", 318}]
  
  defmap(
    :Count_Sys_Calls_Invoked,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 335, print: true, print_elem: printlist}
  )

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    id = ctx.id

    id_count = Honey.Bpf_helpers.bpf_map_lookup_elem(:Count_Sys_Calls_Invoked, id)

    Honey.Bpf_helpers.bpf_map_update_elem(:Count_Sys_Calls_Invoked, id, id_count + 1)

    0
  end
end
