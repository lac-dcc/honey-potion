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
      raise "Module #{env.module} is using eBPF but does not contain #{target_func}/#{target_arity}."
    end

    # Otherwise return its definiton.
    main_def
  end

  @doc """

  """
  def ensure_valid_exports!() do
    Honey.ExportedCLibraries.check!()
    Honey.ExportedSecs.check!()
  end
end
