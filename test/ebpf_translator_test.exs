defmodule HoneyTest do
  use ExUnit.Case
  doctest Honey

  test "greets the world" do
    assert Honey.hello() == :world
  end
end
