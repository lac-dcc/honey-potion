defmodule Test1 do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
  Honey.Bpf.Bpf_helpers.bpf_printk(["Hello world!", nil])
  a = 5
  end
end
