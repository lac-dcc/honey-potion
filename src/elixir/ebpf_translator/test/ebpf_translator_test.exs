defmodule EbpfTranslatorTest do
  use ExUnit.Case
  doctest EbpfTranslator

  test "greets the world" do
    assert EbpfTranslator.hello() == :world
  end
end
