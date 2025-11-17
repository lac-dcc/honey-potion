defmodule LoggerSupportTest do
  use ExUnit.Case
  alias Honey.Compiler.Translator

  describe "Logger support" do
    test "translates Logger.info with string message" do
      ast = {{:., [], [Logger, :info]}, [], ["Hello world"]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[INFO] Hello world")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.debug with string message and variables" do
      pid_ast = {:pid, [types: Honey.TypeSet.new(Honey.Analysis.ElixirTypes.type_integer())], nil}
      ast = {{:., [], [Logger, :debug]}, [], ["PID: %d", pid_ast]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[DEBUG] PID: %d")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.warn with string message" do
      ast = {{:., [], [Logger, :warn]}, [], ["Warning message"]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[WARN] Warning message")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.warning with string message" do
      ast = {{:., [], [Logger, :warning]}, [], ["Warning message"]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[WARN] Warning message")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.warning with variables" do
      pid_ast = {:pid, [types: Honey.TypeSet.new(Honey.Analysis.ElixirTypes.type_integer())], nil}
      ast = {{:., [], [Logger, :warning]}, [], ["PID too high: %d", pid_ast]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[WARN] PID too high: %d")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.error with string message" do
      ast = {{:., [], [Logger, :error]}, [], ["Error occurred"]}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[ERROR] Error occurred")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.info without message" do
      ast = {{:., [], [Logger, :info]}, [], []}
      context = Honey.Compiler.TranslatorContext.new([])

      result = Translator.to_c(ast, context)

      assert String.contains?(result.code, "[INFO]")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "raises error for unsupported Logger function" do
      ast = {{:., [], [Logger, :unsupported]}, [], ["message"]}
      context = Honey.Compiler.TranslatorContext.new([])

      assert_raise RuntimeError, ~r/Logger.unsupported not supported/, fn ->
        Translator.to_c(ast, context)
      end
    end

    test "both warn and warning produce the same output" do
      context = Honey.Compiler.TranslatorContext.new([])

      warn_ast = {{:., [], [Logger, :warn]}, [], ["Test message"]}
      warning_ast = {{:., [], [Logger, :warning]}, [], ["Test message"]}

      warn_result = Translator.to_c(warn_ast, context)
      warning_result = Translator.to_c(warning_ast, context)

      # Both should generate the same prefix
      assert String.contains?(warn_result.code, "[WARN] Test message")
      assert String.contains?(warning_result.code, "[WARN] Test message")
    end
  end
end
