defmodule DropUdp do
  use Honey, license: "Dual BSD/GPL"

  @sec "xdp_md"
  def main(_ctx) do
    Honey.Ethhdr.init() # Should only be called once!
    protocol = Honey.Ethhdr.ip_protocol() # Grabs the ip_protocol
    if protocol == Honey.Ethhdr.const_udp() do # If it's udp
      port = Honey.Ethhdr.destination_port() # Grab the destination port
      case port do
        3000 -> Honey.Ethhdr.drop() # Drop port 3000
        3001 -> Honey.Ethhdr.set_destination_port(3000) # Redirect 3001 to 3000
        _ -> 0 # Do nothing
      end
    end
    Honey.Ethhdr.pass() # Pass all other cases
  end
end
