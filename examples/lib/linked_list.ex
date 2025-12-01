defmodule Honey_List_Linked do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_) do
    t = [1, :nil]
    t = [2 | t]
    t = [3 | t]

    [_three | a] = t
    [two | _a] = a
    Honey.BpfHelpers.bpf_printk(["%d", two])
    0
  end
end
