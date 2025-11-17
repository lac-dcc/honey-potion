defmodule DiskMonitor do
  use Honey, license: "Dual BSD/GPL"
  alias Honey.BpfHelpers, as: BpfHelpers

  @max_entries 4096
  @read_id 0
  @write_id 1
  @pread64_id 17
  @pwrite64_id 18
  @readv_id 19
  @writev_id 20
  @alert_threshold 10000

  defmap(:read_count, :bpf_hash, [max_entries: @max_entries])
  defmap(:write_count, :bpf_hash, [max_entries: @max_entries])
  defmap(:alert_flag, :bpf_hash, [max_entries: @max_entries])

  @doc """
  Monitors disk I/O system calls (read, write, pread64, pwrite64, readv, writev)
  and counts how many times each process performs them.

  Every time a process reads from or writes to disk, this function increments
  a counter in an eBPF map keyed by the process ID (PID). These counters allow
  us to observe disk I/O patterns per process and detect unusual I/O behavior
  in real time.

  Syscalls tracked:
    * `read`     – Standard read operation
    * `write`    – Standard write operation
    * `pread64`  – Positional read at specific offset
    * `pwrite64` – Positional write at specific offset
    * `readv`    – Vector read (scatter-gather)
    * `writev`   – Vector write (scatter-gather)

  The collected metrics can later be queried from user-space for
  debugging, monitoring, or performance analysis purposes.
  """
  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    pid = BpfHelpers.bpf_get_current_pid_tgid()
    syscall_id = ctx.id

    cond do
      pid == 0 ->
        0

      syscall_id == @read_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:read_count, pid, new_count)
        write_total = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        total_calls = new_count + write_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; read: %llu;", pid, new_count])

      syscall_id == @write_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:write_count, pid, new_count)
        read_total = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        total_calls = read_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; write: %llu;", pid, new_count])

      syscall_id == @pread64_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:read_count, pid, new_count)
        write_total = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        total_calls = new_count + write_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; pread64: %llu;", pid, new_count])

      syscall_id == @pwrite64_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:write_count, pid, new_count)
        read_total = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        total_calls = read_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; pwrite64: %llu;", pid, new_count])

      syscall_id == @readv_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:read_count, pid, new_count)
        write_total = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        total_calls = new_count + write_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; readv: %llu;", pid, new_count])

      syscall_id == @writev_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:write_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:write_count, pid, new_count)
        read_total = BpfHelpers.bpf_map_lookup_elem(:read_count, pid, 0)
        total_calls = read_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total I/O calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; writev: %llu;", pid, new_count])

      true ->
        0
    end

    0
  end
end
