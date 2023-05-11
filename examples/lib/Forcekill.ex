defmodule Forcekill do
  use Honey, license: "Dual BSD/GPL"

  defmap(
    :kills,
    %{type: BPF_MAP_TYPE_HASH, max_entries: 64}
  )

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(ctx) do
    sig = ctx.sig
    pid = ctx.pid

    cond do
      sig == 9 ->
        Honey.Bpf_helpers.bpf_map_update_elem(:kills, pid, 1, :BPF_NOEXIST)

        0
      true ->
        0
    end
    0
  end
end
