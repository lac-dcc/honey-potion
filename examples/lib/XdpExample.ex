defmodule XdpExample do
  use Honey, license: "Dual BSD/GPL"
  defmap(
    :map,
    %{type: BPF_MAP_TYPE_HASH, max_entries: 256}
  )

  @sec "xdp"
  def main(ctx) do
    eth = Helpers.parse_ethhdr(ctx.data)
    src = eth.h_source

    {found, item} = Bpf.Bpf_helpers.bpf_map_lookup_elem(:map, src)

    count = if(found) do
      item
    else
      1
    end

    Bpf.Bpf_helpers.bpf_map_update_elem(:map, src, count)

    2
  end
end
