defmodule CpuMonitor do
  use Honey, license: "Dual BSD/GPL"

  @max_entries 41943040
  defmap(:start_time, :bpf_array, [max_entries: @max_entries])
  defmap(:total_time, :bpf_array, [max_entries: @max_entries])

  @sec "tracepoint/sched/sched_switch"
  def main(ctx) do
    ts = Honey.BpfHelpers.bpf_ktime_get_ns()

    maxEntries = @max_entries

    prev_pid = ctx.prev_pid
    next_pid = ctx.next_pid

    cond do
      prev_pid > maxEntries ->
        Honey.BpfHelpers.bpf_printk(["PID: Out of Bounds; CPU Time (ns): %llu;", next_pid, 0])

      true ->
        start = Honey.BpfHelpers.bpf_map_lookup_elem(:start_time, prev_pid)
        delta = ts - start
        total = Honey.BpfHelpers.bpf_map_lookup_elem(:total_time, prev_pid)
        Honey.BpfHelpers.bpf_map_update_elem(:total_time, prev_pid, total + delta)
        Honey.BpfHelpers.bpf_map_update_elem(:start_time, next_pid, ts)
        Honey.BpfHelpers.bpf_printk(["PID: %d; CPU Time (ns): %llu;", next_pid, total + delta])
    end
    0
  end
end
