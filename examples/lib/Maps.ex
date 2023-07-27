defmodule Honey_Maps do
  use Honey, license: "Dual BSD/GPL"
  
  # This module exemplifies the usage of maps!
  # See CountSysCalls for a practical use of maps.

  printlist = [{"Entry 0:", 0}, {"Entry 1:", 1}, {"Entry 2:", 2}]

  # defmap is a macro for creating maps.
  # The first atom is the name of the map.
  # After that we have an elixir map with it's properties:
    # type: defines the map type, we only support BPF_MAP_TYPE_ARRAY currently.
    # max_entries: defines the size of the map.
    # print: true defines that there will be a print (optional) and
    # print_elem: [{...}] defines the names and keys of the print. (optional) 

  defmap(
    :Example_map,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 3, print: true, print_elem: printlist}
  )

  defmap(
    :Second_Example_map,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 3, print: true, print_elem: printlist}
  )

  @sec "tracepoint/syscalls/sys_enter_write"
  def main(_ctx) do
    # To get elements from the map, use bpf_map_lookup_elem from Bpf_helpers!
    entry_0 = Honey.Bpf_helpers.bpf_map_lookup_elem(:Example_map, 0)
    entry_1 = Honey.Bpf_helpers.bpf_map_lookup_elem(:Example_map, 1)
    entry_2 = Honey.Bpf_helpers.bpf_map_lookup_elem(:Second_Example_map, 2)

    # To update elements from the map, use bpf_map_update_elem from Bpf_helpers!
    Honey.Bpf_helpers.bpf_map_update_elem(:Example_map, 0, entry_0 + 1)
    Honey.Bpf_helpers.bpf_map_update_elem(:Example_map, 1, entry_1 + 2)
    Honey.Bpf_helpers.bpf_map_update_elem(:Second_Example_map, 2, entry_2 + 3)

    0
  end
end
