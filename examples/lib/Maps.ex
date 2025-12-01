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
  # If print_elem is not set, Honey will attempt to print as much as possible of the map.
  # See Forcekill for an example.
  
  defmap(:Example_map, :bpf_array, [max_entries: 7, print: true])

  defmap(:Second_Example_map, :bpf_array, [max_entries: 5, print: false, print_elem: printlist])

  @sec "tracepoint/syscalls/sys_enter_write"
  def main(_ctx) do
    # To get elements from the map, use bpf_map_lookup_elem from Bpf_helpers!
    entry_0 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 0)
    entry_1 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 1)
    entry_2 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 2)
    entry_3 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 3)
    entry_4 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 4)
    entry_5 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 5)
    entry_6 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 6)
    entry_7 = Honey.BpfHelpers.bpf_map_lookup_elem(:Second_Example_map, 0)
    #entry_8 = Honey.BpfHelpers.bpf_map_lookup_elem(:Example_map, 8) # TODO: delete this line

    # To update elements from the map, use bpf_map_update_elem from Bpf_helpers!
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 0, entry_0 + 1)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 1, entry_1 + 2)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 2, entry_2 + 3)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 3, entry_3 + 4)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 4, entry_4 + 5)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 5, entry_5 + 6)
    Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 6, entry_6 + 7)
    Honey.BpfHelpers.bpf_map_update_elem(:Second_Example_map, 0, entry_7 + 8)
    #Honey.BpfHelpers.bpf_map_update_elem(:Example_map, 8, entry_8 + 9) # TODO: delete this line

    0
  end
end
