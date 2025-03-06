defmodule DCE do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
    if true do
      1 # This one also doesn't show up in DCE, as this if has no return that is kept.
      # Taking out the 0 below makes it be stored.
    else
      Honey.BpfHelpers.bpf_printk(["This will never print!"])
      Honey.BpfHelpers.bpf_printk(["This will also not be in the AST after DCE!"])
    end
    0
  end
end
