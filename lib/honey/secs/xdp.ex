defmodule Honey.Sec.Xdp do
  alias Honey.{Sec}

  use Sec,
    name: "xdp",
    c_argument_type: "struct xdp_md*",
    c_includes: ["linux/if_ether.h", "linux/ip.h", "linux/icmp.h"]
end
