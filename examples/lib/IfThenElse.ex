defmodule If_Then_Else do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(_) do
    c = 42
    # Shows that if and else are possible.

    if (true) do
      Honey.BpfHelpers.bpf_printk(["True"])
    else
      Honey.BpfHelpers.bpf_printk(["False"])
    end
    0
  end
end
