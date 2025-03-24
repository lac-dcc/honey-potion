defmodule Honey.Type do
  defstruct c_type: nil, e_type: nil
  defguard is_type(var) when is_struct(var, Honey.Analysis.ElixirTypes) or is_struct(var, Honey.Analysis.ElixirTypes)

  def receive_type(type) when is_type(type) do
  end
end