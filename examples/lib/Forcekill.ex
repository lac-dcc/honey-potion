defmodule Forcekill do
  use Honey, license: "Dual BSD/GPL"

  # Here we see an example where we can't describe a print_elem because it's a hash.
  # In this case, we can leave print_elem out to print the map.
  # See Maps.ex for more information on maps.
  # This file represents the Forcekill benchmark.
  # Run the program and try doing <kill -9 PID> and see the ID's that were force-killed!

  defmap(
    :kills,
    %{type: BPF_MAP_TYPE_HASH, max_entries: 64, print: true}
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
