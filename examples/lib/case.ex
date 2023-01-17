defmodule Case do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(_) do
    x = 1

    return =
      case x do
        "str" -> 0
        nil -> 0
        false -> 0
        true -> 1
        _ -> x + 1
      end

    Honey.Bpf.Bpf_helpers.bpf_printk(["Result: %d", return])
  end
end
