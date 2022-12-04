defmodule GetPID do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
  Honey.Bpf.Bpf_helpers.bpf_printk(["Current PID: %d", Honey.Bpf.Bpf_helpers.bpf_get_current_pid_tgid()])
  end
end
