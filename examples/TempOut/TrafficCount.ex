defmodule TrafficCount do
  use Honey, license: "Dual BSD/GPL"

  # Defines an eBPF map of the BPF_MAP_TYPE_HASH with 64 entries
  defmap(:TrafficCount, :bpf_hash, [max_entries: 64, print: true, key_size: :char6])

  @sec "xdp_md"
  def main(_ctx) do
    Honey.Ethhdr.init() #Should only be called once!
    src = Honey.Ethhdr.h_source() #Returns a void* to h_source. Maybe should have unique representation?
    
    count = Honey.BpfHelpers.bpf_map_lookup_elem(:TrafficCount, src, 0)
    count = count + 1

    Honey.BpfHelpers.bpf_map_update_elem(:TrafficCount, src, count)
    
    Honey.XDP.pass()
  end
end
