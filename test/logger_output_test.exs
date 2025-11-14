defmodule TestLoggerOutput do
  use ExUnit.Case
  alias Honey.Compiler.Translator

  test "complete Logger example generates correct C code" do
    ast =
      {:__block__, [],
       [
         {{:., [], [Logger, :info]}, [], ["Starting program"]},
         {:=, [],
          [
            {:pid, [types: Honey.TypeSet.new(Honey.Analysis.ElixirTypes.type_integer())], nil},
            {{:., [], [Honey.BpfHelpers, :bpf_get_current_pid_tgid]}, [], []}
          ]},
         {{:., [], [Logger, :debug]}, [],
          [
            "PID: %d",
            {:pid, [types: Honey.TypeSet.new(Honey.Analysis.ElixirTypes.type_integer())], nil}
          ]},
         {{:., [], [Logger, :warn]}, [], ["Warning message (deprecated)"]},
         {{:., [], [Logger, :warning]}, [], ["Warning message (preferred)"]},
         {{:., [], [Logger, :error]}, [], ["Error occurred"]}
       ]}

    context = Honey.Compiler.TranslatorContext.new([])
    result = Translator.to_c(ast, context)

    assert String.contains?(result.code, "[INFO] Starting program")
    assert String.contains?(result.code, "[DEBUG] PID: %d")
    assert String.contains?(result.code, "[WARN] Warning message (deprecated)")
    assert String.contains?(result.code, "[WARN] Warning message (preferred)")
    assert String.contains?(result.code, "[ERROR] Error occurred")

    bpf_printk_count =
      result.code
      |> String.split("bpf_printk")
      |> length()
      |> Kernel.-(1)

    assert bpf_printk_count == 5

    IO.puts("\n=== Generated C Code ===")
    IO.puts(result.code)
    IO.puts("========================\n")
  end
end
