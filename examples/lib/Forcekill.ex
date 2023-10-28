defmodule Forcekill do
  use Honey, license: "Dual BSD/GPL"

  defmap( # Defines an eBPF map of the BPF_MAP_TYPE_HASH with 64 entries
    :ForceKills,
    %{type: BPF_MAP_TYPE_HASH, max_entries: 64, print: true}
  )

  @sec "tracepoint/syscalls/sys_enter_kill" # Sets our trigger to be sys_enter_kill
  def main(ctx) do
    sig = ctx.sig # Grabs the sig and pid from the ctx variable
    pid = ctx.pid

    cond do
      sig == 9 -> # In case the kill had the sig of 9 (kill -9 <PID>)
        Honey.Bpf_helpers.bpf_map_update_elem(:ForceKills, pid, 1, :BPF_NOEXIST) # Keeps 1 in the <pid> key of the map
    end
    0
  end
end
