defmodule GetPID do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do

    x = 5

    #Shows how to use c-like arguments on string.

    Honey.BpfHelpers.bpf_printk(["Current PID: %d; Another number: 5", Honey.BpfHelpers.bpf_get_current_pid_tgid(), x])
  end
end
