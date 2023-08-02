defmodule Honey.Test.Translation do
  use ExUnit.Case

  defmodule JustCompiles do
    use Honey, license: "oops"

    @sec "tracepoint/syscalls/sys_enter_kill"
    def main(_ctx) do
      1
    end
  end
end
