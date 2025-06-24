defmodule CP do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
    # This program will have constants propagated forward!
    a = 5;b = 6;c = 2;d = 4; e = 1; 
    f = a + b + c + d + e
    f
  end
end
