defmodule Honey do
  @moduledoc """
  Honey Potion is a framework that brings the powerful eBPF technology into Elixir.
  Users can write Elixir code that will be transformed into eBPF bytecodes.
  Many high-level features of Elixir are available and more will be added soon.
  In this alpha version, the framework translates the code to a subset of C that uses libbpf's features.
  Then it's possible to use clang to obtain the bytecodes and load it into the Kernel.

  ## Aliases

  - `Mix.Task.Compiler`: Manages compilation tasks.
  - `Honey.Guard`: Stops execution if main doesn't exist.
  - `Honey.Fuel`: Unrolls function calls.
  - `Honey.Optimizer`: Optimizes the AST with DCE (Dead Code Elimination) and CP (Constant Propagation) and performs variable analysis.
  - `Honey.Info`: Gathers information about the AST.
  - `Honey.Generator`: Uses the gathered info to generate frontend and backend code.
  - `Honey.Write`: Writes files into the appropriate folders for compilation.
  - `Honey.Compiler`: Compiles the files into `userdir/bin/`.
  """
  alias Mix.Task.Compiler
  alias Honey.Guard
  alias Honey.Fuel
  alias Honey.Optimizer
  alias Honey.Info
  alias Honey.Generator
  alias Honey.Write
  alias Honey.Compiler

  @doc """
  Honey-Potion runs using the __before_compile__ macro. So here is where we keep the Honey-Potion pipeline.
  """
  defmacro __before_compile__(env) do
    main_def = Guard.main_exists!(env)

    {arguments, func_ast} = Info.get_ast(main_def)

    final_ast = func_ast |> Fuel.burn_fuel(env) |> Optimizer.run(arguments, env)

    {backend_code, frontend_code} = Generator.generate_code(env, final_ast)

    Write.write_ouput_files(backend_code, frontend_code, env)

    Compiler.compile_bpf(env)

    Module.delete_definition(env.module, {_target_func = :main, _target_arity = 1})

    quote do
      def main(unquote(arguments)) do
        unquote(final_ast)
      end
    end
  end

  @doc """
  Macro that allows users to define maps in eBPF through elixir.
  Users can define maps using the macro defmap. For example, to create a map named my_map, you can:

  ```
  defmap(:my_map,
      %{type: BPF_MAP_TYPE_ARRAY,
      max_entries: 10}
  )
  ```

  In the current version, the types of maps available are:

    - BPF_MAP_TYPE_ARRAY: You only need to specify the maximum number of entries (max_entries) and the map is ready to use.
    - BPF_MAP_TYPE_HASH: The key is an integer, and you only need to provide the maximum number of entries (max_entries) and the map is ready to use,
    - BPF_MAP_TYPE_PERCPU_ARRAY: Same as BPF_MAP_TYPE_ARRAY.
    - BPF_MAP_TYPE_PERCPU_HASH: Same as BPF_MAP_TYPE_HASH.
  """
  defmacro defmap(ebpf_map_name, ebpf_map) do
    quote do
      ebpf_map_name = unquote(ebpf_map_name)
      ebpf_map_content = unquote(ebpf_map)
      @ebpf_maps %{name: ebpf_map_name, content: ebpf_map_content}
    end
  end

  @doc """
  Makes sure the "use" keyword is inside a valid module to operate in and imports the modules that will be needed.
  """
  defmacro __using__(options) do
    with :error <- Keyword.fetch(options, :license) do
      raise "License is required when using the module Honey. Try 'use Honey, license: \"License type\"'."
    end

    if length(Module.get_attribute(__CALLER__.module, :before_compile)) != 0 do
      raise "Honey: Module #{__CALLER__.module} has already set the before_compile attribute."
    end

    Module.register_attribute(__CALLER__.module, :ebpf_maps, accumulate: true)

    quote do
      import Honey.Fuel
      import Honey
      @before_compile unquote(__MODULE__)
      @on_definition unquote(__MODULE__)
      @sections %{}
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

  @doc false
  def print_ast(ast) do
    IO.puts("\nFinal code of main/1 after all fuel burned:")
    IO.puts(Macro.to_string(ast) <> "\n")
    IO.inspect(ast)
    IO.puts("")
  end
end
