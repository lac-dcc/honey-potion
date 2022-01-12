defmodule Ebpf do
  defmacro __using__(_opts) do
    if length(Module.get_attribute(__CALLER__.module, :before_compile)) != 0 do
      raise "EBPF: Module #{__CALLER__.module} has already set the before_compile attribute."
    else
      Module.put_attribute(__CALLER__.module, :before_compile, __MODULE__)
    end

    quote do
      import Fuel
    end
  end

  defmacro __before_compile__(env) do
    IO.puts("Starting Inliner.before_compile...")
    main_def = Module.get_definition(env.module, {:main, 0})

    main_def ||
      Utils.compile_error!(env, "Module #{env.module} is using Ebpf but does not contain main/0.")

    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {_metadata, _arguments, _guards, func_ast} = first_clause

    final_ast =
      Fuel.burn_fuel(func_ast, env)
      |> Optimizer.run()

    print_ast(final_ast)
    Translator.translate(final_ast, "main")

    quote do
      Module.delete_definition(__MODULE__, {:main, 0})

      def main do
        unquote(final_ast)
      end
    end
  end

  def print_ast(ast) do
    IO.puts("\nFinal code of main/0 after all fuel burned:")
    IO.puts(Macro.to_string(ast) <> "\n")
    IO.inspect(ast)
    IO.puts("")
  end
end
