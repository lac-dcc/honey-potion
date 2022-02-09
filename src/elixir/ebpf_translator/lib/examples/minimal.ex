defmodule T do
  use Ebpf, [license: "Dual BSD/GPL"]

  import Linux.Bpf
  import Bpf.Bpf_helpers

  @sec "tp/syscalls/sys_enter_write"
  def main do
    hmm = "?"
    pid = bpf_get_current_pid_tgid()
    bpf_printk(["BPF triggered from PID %d.\n", pid])
    0
  end
end
