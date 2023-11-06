defmodule DropUdp do
  use Honey, license: "Dual BSD/GPL"

  @sec "xdp_md"
  def main(_ctx) do
    drop_port = 3000
    redirect_port = 3001
    Honey.Ethhdr.init() # Should only be called once!
    protocol = Honey.Ethhdr.ip_protocol() # Grabs the ip_protocol
    if protocol == Honey.Ethhdr.const_udp() do # If it's udp
      port = Honey.Ethhdr.destination_port() # Grab the destination port
       cond do
        port == drop_port -> Honey.Ethhdr.drop() # Drop port 3000
        port == redirect_port -> Honey.Ethhdr.set_destination_port(drop_port) # Redirect 3001 to 3000
        true -> 0 # Do nothing
      end
    end
    Honey.Ethhdr.pass() # Pass all other cases
  end
end
