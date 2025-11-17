defmodule LoggerInterpolationTest do
  use ExUnit.Case
  alias Honey.Compiler.Translator

  test "Logger.info with string interpolation" do
    ast = {{:., [], [Logger, :info]}, [], [{:<<>>, [], ["PID: ", {:pid, [], nil}]}]}

    result = Translator.to_c(ast, {})

    assert String.contains?(result.code, "bpf_printk")
    assert String.contains?(result.code, "[INFO] PID: %d")
    assert String.contains?(result.code, "pid")
  end

  test "Logger.debug with multiple interpolations" do
    ast =
      {{:., [], [Logger, :debug]}, [],
       [{:<<>>, [], ["User ", {:user, [], nil}, " has PID ", {:pid, [], nil}]}]}

    result = Translator.to_c(ast, {})

    assert String.contains?(result.code, "bpf_printk")
    assert String.contains?(result.code, "[DEBUG] User %d has PID %d")
    assert String.contains?(result.code, "user")
    assert String.contains?(result.code, "pid")
  end

  test "Logger.error without interpolation still works" do
    ast = {{:., [], [Logger, :error]}, [], ["Simple message"]}

    result = Translator.to_c(ast, {})

    assert String.contains?(result.code, "bpf_printk")
    assert String.contains?(result.code, "[ERROR] Simple message")
  end
end
