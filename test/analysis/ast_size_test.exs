defmodule Honey.Analysis.AstSizeTest do
    use ExUnit.Case
    import ExUnit.CaptureIO
  
    alias Honey.Analysis.AstSize
    alias Honey.Utils.Core
  
    describe "output/3" do
      test "returns the original AST" do
        ast = quote do: 1
        env = __ENV__
        assert AstSize.output(ast, env) == ast
      end
  
      test "outputs correct size for a simple AST" do
        ast = quote do: 1
        env = __ENV__
        expected_output = "#{Core.module_name(env)} - 1\n"
  
        assert capture_io(fn ->
          AstSize.output(ast, env)
        end) == expected_output
      end
  
      test "outputs correct size for a complex AST" do
        ast = quote do: 1 + 2
        env = __ENV__
        {_, expected_size} = Macro.postwalk(ast, 0, fn _, acc -> {nil, acc + 1} end)
        expected_output = "#{Core.module_name(env)} - #{expected_size}\n"
  
        assert capture_io(fn ->
          AstSize.output(ast, env)
        end) == expected_output
      end
  
      test "includes step suffix in the output" do
        ast = quote do: 1
        step_suffix = "_test_suffix"
        env = __ENV__
        expected_output = "#{Core.module_name(env)} - 1#{step_suffix}\n"
  
        assert capture_io(fn ->
          AstSize.output(ast, env, step_suffix)
        end) == expected_output
      end
    end
  end