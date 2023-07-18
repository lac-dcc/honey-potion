defmodule Honey.Sec.Xdp do
  alias Honey.{Sec}

  type = Honey.CType.Ctx_xdp_md.new()

  use Sec,
    name: "xdp",
    c_ctx_arg_type: type,
    c_includes: ["linux/if_ether.h", "linux/ip.h", "linux/icmp.h"]
end
