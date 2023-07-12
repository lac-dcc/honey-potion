defmodule Forcekill do
  use Honey, license: "Dual BSD/GPL"

  # This module follows the Forcekill benchmark.
  # Counts the number of forcekills that have happened with the "type" 9.
  # Currently uses a front-end that is located in /../frontends/Forcekill.c.
  # To use that front-end, make sure to replace the /src/ frontend with the one above and
  # recompile the program with "make prog=Forcekill"
  # With that front-end, the program runs for 30 seconds, then prints out the counted Forcekills.
  # To simmulate a "type 9" forcekill, run "kill -9 <PID>" for any valid PID.

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
