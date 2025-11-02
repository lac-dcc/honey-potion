defmodule Honey.Runtime.TranslatedCode do
  @moduledoc """
  Defines the struct that keeps the translated code and its constructor.
  """
  alias Honey.Compiler.TranslatorContext
  alias Honey.Runtime.MemoryBlocks
  alias Honey.Analysis.ElixirTypes
  alias Honey.TypeSet

  defstruct [:code, :return_var_name, :return_var_type, :context]

  @doc """
  A constructor for the struct that holds the translated code with a standard value.
  The standard value, when no parameters are passed, is an empty code and a return_var_name of "0var_name_err".
  """
  def new(
        code \\ "",
        return_var_name \\ "0var_name_err",
        return_var_type \\ TypeSet.new(ElixirTypes.type_any())
      ) do
    %__MODULE__{code: code, return_var_name: return_var_name, return_var_type: return_var_type}
  end
end
