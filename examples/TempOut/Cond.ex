defmodule Cond do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(_) do
    x = 32
      cond do
        x == 23 -> Honey.BpfHelpers.bpf_printk(["Is 23."])
        x == 23445 -> Honey.BpfHelpers.bpf_printk(["Is 23445."])
        x == 51234 -> Honey.BpfHelpers.bpf_printk(["Is 51234."])
        x== 32 -> Honey.BpfHelpers.bpf_printk(["Is 32."])
      end
    0
  end
end
