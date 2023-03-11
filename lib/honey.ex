defmodule Honey do
  alias Mix.Task.Compiler
  alias Honey.{Utils, Fuel}
  alias Honey.Write
  alias Honey.Generator
  alias Honey.Compiler

  @moduledoc """
  Honey Potion is a framework that brings the powerful eBPF technology into Elixir.
  Users can write Elixir code that will be transformed into eBPF bytecodes.
  Many high-level features of Elixir are available and more will be added soon.
  In this alpha version, the framework translates the code to a subset of C that uses libbpf's features.
  Then it's possible to use clang to obtain the bytecodes and load it into the Kernel.
  """

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

  @doc """
  Macro that allows users to define maps in eBPF through elixir.
  Users can define maps using the macro defmap. For example, to create a map named my_map, you can:

  ```
  defmap(:my_map,
      %{type: BPF_MAP_TYPE_ARRAY,
      max_entries: 10}
  )
  ```

  In the Alpha version, just the map type BPF_MAP_TYPE_ARRAY is available, but you only need to specify the number of entries and the map is ready to use.
  """

  defmacro defmap(ebpf_map_name, ebpf_map) do
    quote do
      ebpf_map_name = unquote(ebpf_map_name)
      ebpf_map_content = unquote(ebpf_map)
      @ebpf_maps %{name: ebpf_map_name, content: ebpf_map_content}
    end
  end

  @doc """
  Honey-Potion runs using the __before_compile__ macro. So here is where we keep the Honey-Potion pipeline. 
  """

  defmacro __before_compile__(env) do
    #This can go into a new "Guard" module.
    target_func = :main
    target_arity = 1
    #If the main function isn't defined raise an error.
    if !(main_def = Module.get_definition(env.module, {target_func, target_arity})) do
      Utils.compile_error!(
        env,
        "Module #{env.module} is using eBPF but does not contain #{target_func}/#{target_arity}."
      )
    end

    #This can go into Utils as ExtractAst or into Info with same name.
    # TODO: evaluate all clauses
    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {_metadata, arguments, _guards, func_ast} = first_clause

    #This can become a one-line call.
    #Burns Fuel (expands recursive calls into repetitions) and runs the optimizer on the AST.
    final_ast = func_ast |> Fuel.burn_fuel(env) # |> Optimizer.run()

    {backend_code, frontend_code} = Generator.generate_code(env, final_ast)

    Write.write_ouput_files(backend_code, frontend_code, env)

    Compiler.compile_bpf(env)

    Module.delete_definition(env.module, {target_func, target_arity})

    quote do
      def main(unquote(arguments)) do
        unquote(final_ast)
      end
    end
  end

  @doc false
  def print_ast(ast) do
    IO.puts("\nFinal code of main/1 after all fuel burned:")
    IO.puts(Macro.to_string(ast) <> "\n")
    IO.inspect(ast)
    IO.puts("")
  end
end
