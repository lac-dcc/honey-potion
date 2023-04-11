defmodule Countsyscalls do
  use Honey, license: "Dual BSD/GPL"

  # This module uses a frontend located in the folder frontends in the above directory.
  # To use it make sure to first run mix compile --force to generate backend, then move the
  # frontend to the src directory (overwrite) then run make TARGET=CountSysCalls.
  # Now the binary has the front-end that every three seconds prints the map!

  defmap(
    :map_traffic,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 335}
  )

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do
    id = ctx.id

    id_count = Honey.Bpf.Bpf_helpers.bpf_map_lookup_elem(:map_traffic, id)

    Honey.Bpf.Bpf_helpers.bpf_map_update_elem(:map_traffic, id, id_count + 1)

    0
  end
end
