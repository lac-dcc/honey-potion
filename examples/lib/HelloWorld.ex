defmodule HelloWorld do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_write"
  def main(_ctx) do

    # Shows how to print to /sys/kernel/debug/tracing/trace_pipe.

    Honey.Bpf.Bpf_helpers.bpf_printk(["Hello world!", nil])
  end
end
