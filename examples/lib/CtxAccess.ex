defmodule CtxAccess do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(ctx) do

    #Shows how to access ctx arguments (Make sure to name the argument ctx!).

    targetid = ctx.pid
    Honey.BpfHelpers.bpf_printk(["PID of callee: %d; PID of target: %d;", Honey.BpfHelpers.bpf_get_current_pid_tgid(), targetid])
  end
end
