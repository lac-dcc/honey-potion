defmodule Honey.Guard do
  alias Honey.Utils

  @moduledoc """
  Contains functions used to guard certain parts of code.
  """

  @doc """
  Guarantees that we have a main module to translate. Also returns its definition.
  """

  def get_main_definition!(env) do
    target_func = :main
    target_arity = 1

    # If the main function isn't defined raise an error.
    if !(main_def = Module.get_definition(env.module, {target_func, target_arity})) do
      Utils.compile_error!(
        env,
        "Module #{env.module} is using eBPF but does not contain #{target_func}/#{target_arity}."
      )
    end

    # Otherwise return its definiton.
    main_def
  end

  @doc """
  Guarantees we have a valid type in the sec argument for an eBPF program. Only three types in alpha.
  """

  @supported_types ~w(tracepoint/syscalls/sys_enter_kill tracepoint/syscalls/sys_enter_write tracepoint/raw_syscalls/sys_enter xdp_traffic_count xdp)
  def ensure_sec_type!(type) do
    case type do
      type when type in @supported_types ->
        true

      type when type in ["", nil] ->
        raise "The main/1 function must be preceded by a @sec indicating the type of the eBPF program."

      type ->
        raise "We cannot convert this Program Type yet: #{type}"
    end
  end

  @doc """

  """
  def ensure_exports_exists!() do
    Honey.ExportedCLibraries.get()
    |> Enum.each(fn module ->
      case Code.ensure_loaded(module) do
        {:module, _} ->
          nil

        {:error, :nofile} ->
          raise "Module #{module} is being exported in c_libraries/exported_c_libraries, but it does not exist."

        x ->
          raise "Module #{module} is being exported in c_libraries/exported_c_libraries, but Honey.Translator cannot load it: #{x}"
      end
    end)

    Honey.ExportedSecs.get()
    |> Enum.each(fn module ->
      case Code.ensure_loaded(module) do
        {:module, _} ->
          nil

        {:error, :nofile} ->
          raise "Module #{module} is being exported in secs/exported_secs, but it does not exist."

        x ->
          raise "Module #{module} is being exported in secs/exported_secs, but Honey.Translator cannot load it: #{x}"
      end
    end)
  end
end
