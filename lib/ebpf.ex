defmodule Honey do
  defmacro __using__(options) do
    case Keyword.fetch(options, :license) do
      {:ok, license} ->
        license
      :error ->
        raise "License is required when using the module Honey. Try 'use Honey, license: \"License type\"'."
    end

    if length(Module.get_attribute(__CALLER__.module, :before_compile)) != 0 do
      raise "Honey: Module #{__CALLER__.module} has already set the before_compile attribute."
    else
      Module.put_attribute(__CALLER__.module, :before_compile, __MODULE__)
      Module.put_attribute(__CALLER__.module, :on_definition, __MODULE__)
    end

    quote do
      import Honey.Fuel
      import Honey
      @sections %{}
      @ebpf_maps []
      @ebpf_options unquote(options)
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

  def write_c_file(c_code, proj_path, module_name, {use_clang_format, clang_format_path}) do
    c_path =
      String.split(proj_path, "/")
      |> Enum.reverse()

    module_name = Atom.to_string(module_name)
    |> String.replace("Elixir.", "")

    c_filename = "#{module_name}.bpf.c"

    c_path = tl(c_path)

    c_path =
      [c_filename | c_path]
      |> Enum.reverse()
      |> Enum.join("/")

    {:ok, file} = File.open(c_path, [:write])
    IO.binwrite(file, c_code)
    File.close(file)

    # Optional, format the file using clang-format:
    if(use_clang_format) do
      System.cmd(clang_format_path, ["-i", c_path])
    end
    true
  end

  defmacro defmap(ebpf_map_name, ebpf_map) do
    quote do
      ebpf_maps = Module.get_attribute(__MODULE__, :ebpf_maps)
      ebpf_map_name = unquote(ebpf_map_name)
      ebpf_map_content = unquote(ebpf_map)
      ebpf_maps = [%{name: ebpf_map_name, content: ebpf_map_content} | ebpf_maps]
      Module.put_attribute(__MODULE__, :ebpf_maps, ebpf_maps)
    end
  end

  defmacro __before_compile__(env) do
    target_func = :main
    target_arity = 1

    main_def = Module.get_definition(env.module, {target_func, target_arity})

    main_def ||
      Honey.Utils.compile_error!(env, "Module #{env.module} is using Ebpf but does not contain main/1.")

    # TODO: evaluate all clauses
    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {_metadata, arguments, _guards, func_ast} = first_clause

    final_ast = func_ast
    |> Honey.Fuel.burn_fuel(env)
    |> Honey.Optimizer.run()

    # print_ast(final_ast)

    ebpf_options = Module.get_attribute(env.module, :ebpf_options)

    sections = Module.get_attribute(env.module, :sections)
    sec = Map.get(sections, {:def, target_func, target_arity})
    license = Keyword.fetch!(ebpf_options, :license)
    maps = Module.get_attribute(env.module, :ebpf_maps)
    # TODO: env.requires stores the requires in alphabetical order. This might be a problem.
    c_code = Honey.Translator.translate("main", final_ast, sec, license, env.requires, maps)

    clang_format_option = case Keyword.fetch(ebpf_options, :clang_format) do
      {:ok, clang_format_path} ->
        {true, clang_format_path}

      :error ->
        {false, nil}
    end
    write_c_file(c_code, env.file, env.module, clang_format_option)

    quote do
      Module.delete_definition(__MODULE__, {unquote(target_func), unquote(target_arity)})

      def main(unquote(arguments)) do
        unquote(final_ast)
      end
    end
  end

  def print_ast(ast) do
    IO.puts("\nFinal code of main/1 after all fuel burned:")
    IO.puts(Macro.to_string(ast) <> "\n")
    IO.inspect(ast)
    IO.puts("")
  end
end
