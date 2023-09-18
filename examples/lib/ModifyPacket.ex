defmodule XdpExample do
  use Honey, license: "Dual BSD/GPL"
  defmap(
    :map,
    %{type: BPF_MAP_TYPE_ARRAY, max_entries: 256}
  )

  @sec "xdp"
  def main(ctx) do
    ethhdr = Honey.Ethhdr.from_binary(ctx.data)
    ethhdr = put_in(ethhdr.h_source, ethhdr.h_dest)
    Honey.Xdp.update_data(ethhdr)
    2
  end
end
