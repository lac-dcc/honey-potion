defmodule Honey.Guard do
  alias Honey.Utils

  @moduledoc """
  Contains functions used to guard certain parts of code.
  """

  @doc """
  Guarantees that we have a main module to translate. Also returns its definition.
  """ 

  def main_exists!(env) do
    target_func = :main
    target_arity = 1
    
    #If the main function isn't defined raise an error.
    if !(main_def = Module.get_definition(env.module, {target_func, target_arity})) do
      Utils.compile_error!(
        env,
        "Module #{env.module} is using eBPF but does not contain #{target_func}/#{target_arity}."
      )
    end
    #Otherwise return its definiton.
    main_def
  end

  @doc """
  Guarantees we have a valid type in the sec argument for an eBPF program. Only three types in alpha.
  """

  @supported_types ~w(tracepoint/syscalls/sys_enter_kill tracepoint/syscalls/sys_enter_write tracepoint/raw_syscalls/sys_enter xdp_md)
  def ensure_sec_type!(type) do
    case type do
      type when type in @supported_types ->
        true

      type when type in ["", nil] ->
        raise "The main/1 function must be preceded by a @sec indicating the type of the program."

      type ->
        raise "We cannot convert this Program Type yet: #{type}"
    end
  end
end
