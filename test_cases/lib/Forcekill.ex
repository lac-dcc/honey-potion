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

    if(sig == 9) do
      Honey.Bpf_helpers.bpf_map_update_elem(:kills, pid, 1, :BPF_NOEXIST)
    end

    0
  end
end
