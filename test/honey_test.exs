defmodule HoneyTest do
  use ExUnit.Case

  use Honey, license: "oops"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(_ctx) do
    1
  end
end
