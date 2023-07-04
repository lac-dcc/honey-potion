defmodule Honey_Tuple do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_) do

    # Shows that pattern matching on tuples is possible
    y = 2
    {1, {2, {"some string", x}}} = {1, {y, {"some string", 4}}}
    Honey.Bpf_helpers.bpf_printk(["x: %d", x])
  end
end
