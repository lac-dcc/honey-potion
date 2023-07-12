# IN PROGRESS

defmodule XdpExample do
  use Honey, license: "Dual BSD/GPL"
  defmap(
    :map,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 256}
  )

  @sec "xdp"
  def main(ctx) do
    # eth = Honey.Helpers.parse_ethhdr(ctx.data)
    # src = eth.h_source

    item = Honey.Bpf_helpers.bpf_map_lookup_elem(:map, 1)

    count = cond do
      item ->
        item
      true ->
        true
    end

    Honey.Bpf_helpers.bpf_map_update_elem(:map, 1, count)

    2
  end
end
