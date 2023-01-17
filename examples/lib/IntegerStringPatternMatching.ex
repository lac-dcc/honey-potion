defmodule Integer_String_Pattern_Matching do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
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
