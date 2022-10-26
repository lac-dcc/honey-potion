defmodule IntegerStringPatternMatching do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_) do
    x = 1
    str = "foo"
    1 = x
    "foo" = str
    Honey.Bpf.Bpf_helpers.bpf_printk(["Success"])

    # The following line raises an error:
    "bar" = str
  end
end
