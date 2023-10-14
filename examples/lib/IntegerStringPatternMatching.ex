defmodule Integer_String_Pattern_Matching do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(_) do

    #Shows that PatternMatching is possible.

    x = 1
    str = "foo"
    1 = x
    "foo" = str
    Honey.Bpf_helpers.bpf_printk(["Success"])

    # The following line raises an error:
    "bar" = str
    0
  end
end
