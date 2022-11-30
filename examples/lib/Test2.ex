defmodule Test2 do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
  Honey.Bpf.Bpf_helpers.bpf_printk(["Goodbye world!", nil])
  end
end
