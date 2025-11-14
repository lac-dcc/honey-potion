defmodule LoggerSupportTest do
  use ExUnit.Case
  alias Honey.Compiler.Translator

  describe "Logger support" do
    test "translates Logger.info with string message" do
      # Simular AST para Logger.info("Hello world")
      ast = {{:., [], [Logger, :info]}, [], ["Hello world"]}
      context = Honey.Compiler.TranslatorContext.new([])
      
      result = Translator.to_c(ast, context)
      
      # Verificar se contém o prefixo [INFO] e a chamada bpf_printk
      assert String.contains?(result.code, "[INFO] Hello world")
      assert String.contains?(result.code, "bpf_printk")
    end

    test "translates Logger.debug with string message and variables" do
      # Simular AST para Logger.debug("PID: %d", pid)
      pid_ast = {:pid, [types: Honey.TypeSet.new(Honey.Analysis.ElixirTypes.type_integer())], nil}
      ast = {{:., [], [Logger, :debug]}, [], ["PID: %d", pid_ast]}
      context = Honey.Compiler.TranslatorContext.new([])
      
      result = Translator.to_c(ast, context)
      
      # Verificar se contém o prefixo [DEBUG]
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
  end
end