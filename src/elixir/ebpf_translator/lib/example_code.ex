defmodule T do
  use Ebpf

  def sum(a, b) do
    if b == 0 do
      a
    else
      sum(a + 1, b - 1)
    end
  end

  def main do
    var = 100
    s = fuel(10, sum(3, 6))
    var + s
  end
end
