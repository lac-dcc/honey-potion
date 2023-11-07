defmodule Honey_Fact do
  use Honey, license: "Dual BSD/GPL"

  def fact(x) do
    if x == 1 do
      1
    else
      x * fact(x - 1)
    end
  end

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    const = 3
    id = ctx.id
    a = fuel 2, fact(const)
    b = fuel 1, fact(id)
    c = a + b
    Honey.Bpf_helpers.bpf_printk(["%d", c])
  end
end

