defmodule MemoryMonitor do
  use Honey, license: "Dual BSD/GPL"

  @max_entries 41943040
  defmap(:mmap_count, :bpf_array, [max_entries: @max_entries])
  defmap(:munmap_count, :bpf_array, [max_entries: @max_entries])
  defmap(:brk_count, :bpf_array, [max_entries: @max_entries])

  @doc """
   Monitors memory-related system calls (`mmap`, `munmap`, `brk`)
   and counts how many times each process performs them.

   Every time a process requests memory, releases memory, or adjusts
   its heap size, this function increments a counter in an eBPF map 
   keyed by the process ID (PID). These counters allow us to observe
   memory pressure patterns per process and detect unusual allocation 
   behavior in real time.

   Syscalls tracked:
     * `mmap`  – Process requests new memory from the OS
     * `munmap` – Process releases previously allocated memory
     * `brk`   – Process grows or shrinks its heap segment

   The collected metrics can later be queried from user-space for
   debugging, monitoring, or performance analysis purposes.
   """
  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    syscall_id = ctx.id
    pid = Honey.BpfHelpers.bpf_get_current_pid_tgid()

    cond do
      syscall_id == 9 -> 
        count = Honey.BpfHelpers.bpf_map_lookup_elem(:mmap_count, pid)
        Honey.BpfHelpers.bpf_map_update_elem(:mmap_count, pid, count + 1)
        Honey.BpfHelpers.bpf_printk(["PID: %d; MMap Operations: %llu;", pid, count + 1])

      syscall_id == 11 ->
        count = Honey.BpfHelpers.bpf_map_lookup_elem(:munmap_count, pid)
        Honey.BpfHelpers.bpf_map_update_elem(:munmap_count, pid, count + 1)
        Honey.BpfHelpers.bpf_printk(["PID: %d; Munmap Operations: %llu;", pid, count + 1])

      syscall_id == 12 ->  # brk
        count = Honey.BpfHelpers.bpf_map_lookup_elem(:brk_count, pid)
        Honey.BpfHelpers.bpf_map_update_elem(:brk_count, pid, count + 1)
        Honey.BpfHelpers.bpf_printk(["PID: %d; Brk Operations: %llu;", pid, count + 1])
    end

    0
  end
end
