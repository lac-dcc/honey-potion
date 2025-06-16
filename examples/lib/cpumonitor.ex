defmodule CpuMonitor do
  use Honey, license: "Dual BSD/GPL"

  defmap(:start_time, :bpf_array, [max_entries: 41943040])
  defmap(:total_time, :bpf_array, [max_entries: 41943040])

  # The following code is the implementation of the eBPF program in C
  # it uses a simplification of the logic of the original C code, implemented at
  # on_sched_switch from the cpumonitor benchmark,
  # to make it easier to understand and adapt to a Benchmark using Honey.

  # u64 ts = bpf_ktime_get_ns();
  # u32 prev_pid = ctx->prev_pid;
  # u32 next_pid = ctx->next_pid;

  # u64 *start = bpf_map_lookup_elem(&start_time, &prev_pid);
  # if (start) {
  #     u64 delta = ts - *start;
  #     u64 *total = bpf_map_lookup_elem(&kernel_time, &prev_pid);  // reusing this map
  #     if (total) *total += delta;
  #     else bpf_map_update_elem(&kernel_time, &prev_pid, &delta, BPF_ANY);
  # }

  # bpf_map_update_elem(&start_time, &next_pid, &ts, BPF_ANY);
  # return 0;


  @sec "tracepoint/sched/sched_switch"
  def main(ctx) do
    ts = Honey.BpfHelpers.bpf_ktime_get_ns()

    maxEntries = 41943040

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
