defmodule GetPID do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do

    #Shows how to use c-like arguments on string.

    Honey.Bpf_helpers.bpf_printk(["Current PID: %d", Honey.Bpf_helpers.bpf_get_current_pid_tgid()])
  end
end
