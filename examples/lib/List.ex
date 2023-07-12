defmodule Honey_List do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_) do
    
    #Shows that pattern matching on lists is possible.

    one_two = {1, 2}
    three = 3
    [_, any_tuple] = [three, one_two]
    {x, _} = any_tuple
    # X must be equals 1
    Honey.Bpf_helpers.bpf_printk(["x: %d", x])
  end
end
