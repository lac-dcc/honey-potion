defmodule Test1 do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
    a = 2
    b = a
    c = a
    a = b
    cond do
      a == 10 -> a
      true -> (cond do
        c == 2 -> 4
      end)
    end
    if a == 3 do
      c == 3
    else
      c == 4
      ^b = 2
    end
  end
end
