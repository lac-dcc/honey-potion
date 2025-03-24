defmodule Forcekill do
  use Honey, license: "Dual BSD/GPL"

  # Defines an eBPF map of the BPF_MAP_TYPE_HASH with 64 entries
  defmap(:ForceKills, :bpf_hash, [max_entries: 64, print: true])

  @sec "tracepoint/syscalls/sys_enter_kill" # Sets our trigger to be sys_enter_kill
  def main(ctx) do
    sig = ctx.sig # Grabs the sig and pid from the ctx variable
    pid = ctx.pid
    target_sig = 9 # What sig we wish to count. In this case 9
    stored_value = 1 # Any integer arbitrary value works!

    cond do
      sig == target_sig -> # In case the kill had the sig of 9 or <target_sig> (kill -9 <PID>)
        Honey.BpfHelpers.bpf_map_update_elem(:ForceKills, pid, stored_value, :BPF_NOEXIST) # Stores a value into the <pid> key. It will be printed from now on.
    end
    0
  end
end
