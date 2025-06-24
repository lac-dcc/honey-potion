defmodule Honey do
  @moduledoc """
  Honey Potion is a framework that brings the powerful eBPF technology into Elixir.
  Users can write Elixir code that will be transformed into eBPF bytecodes.
  Many high-level features of Elixir are available and more will be added soon.
  In this alpha version, the framework translates the code to a subset of C that uses libbpf's features.
  Then it's possible to use clang to obtain the bytecodes and load it into the Kernel.

  ## Aliases

  - `Mix.Task.Compiler`: Manages compilation tasks.
  - `Honey.Utils.Guard`: Stops execution if main doesn't exist.
  - `Honey.AST.RecursionExpansion`: Unrolls function calls.
  - `Honey.Optimization.Optimizer`: Optimizes the AST with DCE (Dead Code Elimination) and CP (Constant Propagation) and performs variable analysis.
  - `Honey.Runtime.Info`: Gathers information about the AST.
  - `Honey.Compiler.CodeGenerator`: Uses the gathered info to generate frontend and backend code.
  - `Honey.Utils.Write`: Writes files into the appropriate folders for compilation.
  - `Honey.Compiler.Pipeline`: Compiles the files into `userdir/bin/`.
  """
  require Logger

  alias Honey.Utils.Guard
  alias Honey.AST.RecursionExpansion
  alias Honey.Optimization.Optimizer
  alias Honey.Runtime.Info
  alias Honey.Compiler.CodeGenerator
  alias Honey.Utils.Write
  alias Honey.Compiler.Pipeline

  @ebpf_types %{
    bpf_array: BPF_MAP_TYPE_ARRAY,
    bpf_hash: BPF_MAP_TYPE_HASH,
    bpf_percpu_array: BPF_MAP_TYPE_PERCPU_ARRAY,
    bpf_percpu_hash: BPF_MAP_TYPE_PERCPU_HASH
  }

  @doc """
  Honey-Potion runs using the __before_compile__ macro. So here is where we keep the Honey-Potion pipeline.
  """
  defmacro __before_compile__(env) do
    with {:ok, main_def} <- safe_main_exists(env),
         {:ok, {arguments, func_ast}} <- safe_get_ast(main_def),
         {:ok, burned_ast} <- safe_burn_fuel(func_ast, env),
         {:ok, final_ast} <- safe_optimize(burned_ast, arguments, env),
         {:ok, {backend_code, frontend_code}} <- safe_generate_code(env, final_ast),
         {:ok, _makefile_path} <- safe_write_output(backend_code, frontend_code, env),
         {_cmd, _exit_code} <- safe_compile_bpf(env),
         :ok <- safe_delete_definition(env.module, :main, 1) do
      quote do
        def main(unquote(arguments)) do
          unquote(final_ast)
        end
      end
    else
      {:error, {:main_exists_error, reason}} ->
        raise "Main function check failed: #{inspect(reason)}"

      {:error, {:get_ast_error, reason}} ->
        raise "AST extraction failed: #{inspect(reason)}"

      {:error, {:burn_fuel_error, reason}} ->
        raise "Recursion expansion failed: #{inspect(reason)}"

      {:error, {:optimize_error, reason}} ->
        raise "Optimization failed: #{inspect(reason)}"

      {:error, {:generate_code_error, reason}} ->
        raise "Code generation failed: #{inspect(reason)}"

      {:error, {:write_output_error, reason}} ->
        raise "File write failed: #{inspect(reason)}"

      {:error, {:compile_bpf_error, reason}} ->
        raise "BPF compilation failed: #{inspect(reason)}"

      {:error, {:delete_definition_error, reason}} ->
        Logger.warning("Definition cleanup failed: #{inspect(reason)}")

      error ->
        Logger.warning("An unknown error occurred during compilation. Details: #{inspect(error)}")
    end
  end

  @doc """
  Macro that allows users to define maps in eBPF through elixir.
  Users can define maps using the macro defmap. For example, to create a map named my_map, you can:

  ```
  defmap(:my_map, :bpf_array, max_entries: 10)
  ```

  In the current version, the ebpf types of maps available are:

    - BPF_MAP_TYPE_ARRAY: You only need to specify the maximum number of entries (max_entries) and the map is ready to use.
    - BPF_MAP_TYPE_HASH: The key is an integer, and you only need to provide the maximum number of entries (max_entries) and the map is ready to use,
    - BPF_MAP_TYPE_PERCPU_ARRAY: Same as BPF_MAP_TYPE_ARRAY.
    - BPF_MAP_TYPE_PERCPU_HASH: Same as BPF_MAP_TYPE_HASH.

  And they are represented by the following atoms

    - :bpf_array
    - :bpf_hash
    - :bpf_percpu_array
    - :bpf_percpu_hash
  """
  defmacro defmap(ebpf_map_name, ebpf_map_type, opts \\ []) do
    ebpf_types = @ebpf_types

    quote do
      ebpf_map_name = unquote(ebpf_map_name)
      ebpf_map_type_atom = unquote(ebpf_map_type)

      ebpf_map_type =
        Map.fetch!(
          unquote(Macro.escape(ebpf_types)),
          ebpf_map_type_atom
        )

      ebpf_map_content = %{type: ebpf_map_type, options: unquote(opts)}
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
      import Honey.AST.RecursionExpansion
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

  defp safe_main_exists(env) do
    try do
      {:ok, Guard.main_exists!(env)}
    rescue
      e -> {:error, {:main_exists_error, e}}
    end
  end

  defp safe_get_ast(main_def) do
    try do
      {:ok, Info.get_ast(main_def)}
    rescue
      e -> {:error, {:get_ast_error, e}}
    end
  end

  defp safe_burn_fuel(func_ast, env) do
    try do
      {:ok, RecursionExpansion.burn_fuel(func_ast, env)}
    rescue
      e -> {:error, {:burn_fuel_error, e}}
    end
  end

  defp safe_optimize(burned_ast, arguments, env) do
    #try do
      {:ok, Optimizer.run(burned_ast, arguments, env)}
    #rescue
    #e -> {:error, {:optimize_error, e}}
    #end
  end

  defp safe_generate_code(env, final_ast) do
    #try do
      {:ok, CodeGenerator.generate_code(env, final_ast)}
      #rescue
      #e -> {:error, {:generate_code_error, e}}
      #end
  end

  defp safe_write_output(backend_code, frontend_code, env) do
    try do
      Write.write_output_files(backend_code, frontend_code, env)
    rescue
      e -> {:error, {:write_output_error, e}}
    end
  end

  defp safe_compile_bpf(env) do
    try do
      {cmd, exit_code} = result = Pipeline.compile_bpf(env)

      if exit_code != 0 do
        Logger.warning("Compilation command: #{cmd} returned #{exit_code}")
      end

      result
    rescue
      e -> {:error, {:compile_bpf_error, e}}
    end
  end

  defp safe_delete_definition(module, func, arity) do
    case Module.delete_definition(module, {func, arity}) do
      true ->
        :ok

      _ ->
        {:error, {:delete_definition_error, false}}
    end
  end
end
