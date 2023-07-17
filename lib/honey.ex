defmodule Honey do
  alias Mix.Task.Compiler
  # Stops execution if main doesn't exist.
  alias Honey.Guard
  # Unrolls function calls.
  alias Honey.Fuel
  # Optimizes the AST with DeadCodeElimination and CP and does variable analysis.
  alias Honey.Optimizer
  # Gathers Info about the AST.
  alias Honey.Info
  # Uses that info to generate frontend and backend code.
  alias Honey.Generator
  # Writes files into the right folders for compilation.
  alias Honey.Write
  # Compiles the files into userdir/bin/
  alias Honey.Compiler

  @moduledoc """
  Honey Potion is a framework that brings the powerful eBPF technology into Elixir.
  Users can write Elixir code that will be transformed into eBPF bytecodes.
  Many high-level features of Elixir are available and more will be added soon.
  In this alpha version, the framework translates the code to a subset of C that uses libbpf's features.
  Then it's possible to use clang to obtain the bytecodes and load it into the Kernel.
  """

  @doc """
  Honey-Potion runs using the __before_compile__ macro. So here is where we keep the Honey-Potion pipeline.
  """

  defmacro __before_compile__(env) do
    main_def = Guard.get_main_definition!(env)

    {_meta, arguments, func_ast} = Info.get_ast(main_def)

    final_ast =
      func_ast
      |> Fuel.burn_fuel(env)
      |> Optimizer.run(arguments, env)

    {backend_code, frontend_code} = Generator.generate_code(env, final_ast)

    Write.write_ouput_files(backend_code, frontend_code, env)

    Compiler.compile_bpf(env)

    update_module(env)
  end

  defp update_module(env) do
    update_defs =
      Module.get_attribute(env.module, :sections)
      |> Enum.map(fn {{_kind, function, arity}, _sec_name} ->
        fun_def = Module.get_definition(env.module, {function, arity})
        {meta, arguments, _func_ast} = Info.get_ast(fun_def)
        module_str = Honey.Utils.custom_atom_to_string(env.module)

        quote do
          Module.delete_definition(__MODULE__, {unquote(function), unquote(arity)})

          def unquote({function, meta, arguments}) do
            raise "The #{unquote(module_str)}.#{unquote(function)}/#{unquote(arity)} function was translated to a C file and that file must be used to interact with eBPF. The module #{unquote(module_str)} and its functions have no effect after compilation."
          end
        end
      end)

    [
      quote do
        @compilation_ended true
      end
      | update_defs
    ]
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

    Guard.ensure_valid_exports!()

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
    compilation_ended = Module.get_attribute(env.module, :compilation_ended)

    if(!compilation_ended) do
      sec = Module.get_attribute(env.module, :sec)

      if(fun == :main and Enum.count(args) == 1 and !sec) do
        raise """
        The main/1 function must be preceded by a @sec indicating the type of the eBPF program. Try:
        @sec "sec_type"
        def main(ctx) do
          # ...
        end
        """
      end

      if sec do
        sections = Module.get_attribute(env.module, :sections)
        sections = Map.put(sections, {kind, fun, length(args)}, sec)
        Module.put_attribute(env.module, :sections, sections)
        Module.put_attribute(env.module, :sec, nil)
      end
    end
  end

  @doc false
  def print_ast_as_code(ast) do
    IO.puts("\nAST as code:")
    IO.puts(Macro.to_string(ast) <> "\n")
    IO.inspect(ast)
    IO.puts("")
  end
end
