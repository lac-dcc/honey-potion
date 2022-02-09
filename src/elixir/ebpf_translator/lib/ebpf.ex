defmodule Ebpf do
  defmacro __using__([license: license]) do
    if length(Module.get_attribute(__CALLER__.module, :before_compile)) != 0 do
      raise "EBPF: Module #{__CALLER__.module} has already set the before_compile attribute."
    else
      Module.put_attribute(__CALLER__.module, :before_compile, __MODULE__)
      Module.put_attribute(__CALLER__.module, :on_definition, __MODULE__)
    end

    quote do
      import Fuel
      import Ebpf
      @sections %{}
      @license unquote(license)
    end
  end

  def __on_definition__(env, kind, fun, args, _guards, _body) do
    if sec = Module.get_attribute(env.module, :sec) do
      sections = Module.get_attribute(env.module, :sections)
      sections = Map.put(sections, {kind, fun, length(args)}, sec)
      Module.put_attribute(env.module, :sections, sections)
      Module.put_attribute(env.module, :sec, nil)
    end
    :ok
  end

  def write_c_file(c_code, elixir_path) do
    c_path = String.split(elixir_path, "/")
    |> Enum.reverse()

    c_filename = List.first(c_path)
    |> String.replace(~r/\.exs$/, ".c")
    |> String.replace(~r/\.ex$/, ".c")

    c_path = tl(c_path)
    c_path = [c_filename | c_path]
    |> Enum.reverse()
    |> Enum.join("/")

    {:ok, file} = File.open(c_path, [:write])
    IO.binwrite(file, c_code)
    File.close(file)

    # Optional, format the file using clang-format:
    System.cmd("/home/vinicius/llvm_versions/11/builds/release/bin/clang-format", ["-i", c_path])
    true
  end

  defmacro __before_compile__(env) do
    main_def = Module.get_definition(env.module, {:main, 0})

    main_def ||
      Utils.compile_error!(env, "Module #{env.module} is using Ebpf but does not contain main/0.")

    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {_metadata, _arguments, _guards, func_ast} = first_clause

    final_ast =
      Fuel.burn_fuel(func_ast, env)
      # |> Optimizer.run()

    print_ast(final_ast)

    sections = Module.get_attribute(env.module, :sections)
    sec = Map.get(sections, {:def, :main, 0})
    license = Module.get_attribute(env.module, :license)
    # TODO: env.requires stores the requires in alphabetical order. This might be a problem.
    c_code = Translator.translate("main", final_ast, sec, license, env.requires)
    write_c_file(c_code, env.file)

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
