defmodule MemoryMonitor do
  use Honey, license: "Dual BSD/GPL"

  @max_entries 41943040
  defmap(:mmap_count, :bpf_array, [max_entries: @max_entries])
  defmap(:munmap_count, :bpf_array, [max_entries: @max_entries])
  defmap(:brk_count, :bpf_array, [max_entries: @max_entries])

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    syscall_id = ctx.id
    pid = Honey.BpfHelpers.bpf_get_current_pid_tgid()

    cond do
      syscall_id == 9 ->  # mmap
        count = Honey.BpfHelpers.bpf_map_lookup_elem(:mmap_count, pid)
        Honey.BpfHelpers.bpf_map_update_elem(:mmap_count, pid, count + 1)
        Honey.BpfHelpers.bpf_printk(["PID: %d; MMap Operations: %llu;", pid, count + 1])

      syscall_id == 11 ->  # munmap
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
