defmodule CtxAccess do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(ctx) do
    targetid = ctx.pid
    Honey.Bpf.Bpf_helpers.bpf_printk(["PID of callee: %d; PID of target: %d;", Honey.Bpf.Bpf_helpers.bpf_get_current_pid_tgid(), targetid])
  end
end
