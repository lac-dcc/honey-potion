defmodule If_Then_Else do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_) do

    if (true) do
      Honey.Bpf.Bpf_helpers.bpf_printk(["True"])
    else
      Honey.Bpf.Bpf_helpers.bpf_printk(["False"])
    end
  end
end
