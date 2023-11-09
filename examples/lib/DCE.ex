defmodule DCE do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
    if true do
      1
    else
      Honey.Bpf_helpers.bpf_printk(["This will never print!"])
      Honey.Bpf_helpers.bpf_printk(["This will also not be in the AST after DCE!"])
    end
  end
  0
end
