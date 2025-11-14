defmodule NetworkMonitor do
  use Honey, license: "Dual BSD/GPL"
  alias Honey.BpfHelpers, as: BpfHelpers

  @max_entries 4096
  @sendto_id 44
  @sendmsg_id 46
  @sendmmsg_id 307
  @recvfrom_id 45
  @recvmsg_id 47
  @recvmmsg_id 299
  @alert_threshold 50000

  defmap(:send_count, :bpf_hash, [max_entries: @max_entries])
  defmap(:recv_count, :bpf_hash, [max_entries: @max_entries])
  defmap(:alert_flag, :bpf_hash, [max_entries: @max_entries])

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    pid = BpfHelpers.bpf_get_current_pid_tgid()
    syscall_id = ctx.id

    cond do
      pid == 0 ->
        0

      syscall_id == @sendto_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:send_count, pid, new_count)
        recv_total = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        total_calls = new_count + recv_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; sendto: %llu;", pid, new_count])

      syscall_id == @sendmsg_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:send_count, pid, new_count)
        recv_total = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        total_calls = new_count + recv_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; sendmsg: %llu;", pid, new_count])

      syscall_id == @sendmmsg_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:send_count, pid, new_count)
        recv_total = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        total_calls = new_count + recv_total
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; sendmmsg: %llu;", pid, new_count])

      syscall_id == @recvfrom_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:recv_count, pid, new_count)
        send_total = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        total_calls = send_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; recvfrom: %llu;", pid, new_count])

      syscall_id == @recvmsg_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:recv_count, pid, new_count)
        send_total = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        total_calls = send_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; recvmsg: %llu;", pid, new_count])

      syscall_id == @recvmmsg_id ->
        count = BpfHelpers.bpf_map_lookup_elem(:recv_count, pid, 0)
        new_count = count + 1
        BpfHelpers.bpf_map_update_elem(:recv_count, pid, new_count)
        send_total = BpfHelpers.bpf_map_lookup_elem(:send_count, pid, 0)
        total_calls = send_total + new_count
        cond do
          total_calls > @alert_threshold ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 1)
            BpfHelpers.bpf_printk(["PID: %llu; alert total calls: %llu;", pid, total_calls])
          true ->
            BpfHelpers.bpf_map_update_elem(:alert_flag, pid, 0)
        end
        BpfHelpers.bpf_printk(["PID: %llu; recvmmsg: %llu;", pid, new_count])

      true ->
        0
    end

    0
  end
end
