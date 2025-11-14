defmodule LoggerInterpolationSimpleTest do
  use ExUnit.Case
  alias Honey.Compiler.Translator

  test "string interpolation through to_c function" do
    interpolation_ast = {:<<>>, [], ["PID: ", {:pid, [], nil}]}

    result = Translator.to_c(interpolation_ast, {})

    assert is_binary(result.code)
    assert String.contains?(result.code, "char")
  end

  test "simple string without interpolation" do
    string_ast = "Hello World"

    result = Translator.to_c(string_ast, {})

    assert is_binary(result.code)
  end
end
