defmodule Honey.TypeSet do
  @moduledoc """
  This module manages the information regarding the types that a variable can assume at
  a point in the code. Uses Honey.Analysis.ElixirTypes to represent the possible types.
  """
  alias Honey.Analysis.ElixirTypes

  import Honey.Utils.Core, only: [is_var: 1]

  defstruct types: MapSet.new()

  def new(arr \\ [])

  def new(arr) when is_list(arr) do
    %__MODULE__{types: MapSet.new(arr)}
  end

  def new(type = %ElixirTypes{}) do
    %__MODULE__{types: MapSet.new([type])}
  end

  def new(typeset = %__MODULE__{}) do
    typeset
  end

  def new(mapset = %MapSet{}) do
    %__MODULE__{types: mapset}
  end

  def put_type(typeset = %__MODULE__{}, type = %ElixirTypes{}) do
    %__MODULE__{typeset | types: MapSet.put(typeset.types, type)}
  end

  def union(type_set_a = %__MODULE__{}, type_set_b = %__MODULE__{}) do
    MapSet.union(type_set_a.types, type_set_b.types)
    |> new()
  end

  def type_is_unique(set = %__MODULE__{}) do
    size(set) == 1
  end

  def has_type(set = %__MODULE__{}, type = %ElixirTypes{}) do
    MapSet.member?(set.types, type)
  end

  def has_unique_type(set = %__MODULE__{}, type = %ElixirTypes{}) do
    size(set) == 1 and has_type(set, type)
  end

  def is_generic?(set = %__MODULE__{}) do
    size(set) > 1 or size(set) == 0 or has_type(set, ElixirTypes.type_any())
  end

  def is_integer?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirTypes.type_integer())
  end

  def is_string?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirTypes.type_bitstring())
  end

  def is_void?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirTypes.type_void())
  end

  def is_atom?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirTypes.type_atom())
  end

  def size(set = %__MODULE__{}) do
    MapSet.size(set.types)
  end

  def is_any(type_set = %__MODULE__{}) do
    size(type_set) == 0
  end

  def get_typeset_from_var_ast({_, meta, _} = var) when is_var(var) do
    Keyword.get(meta, :types, __MODULE__.new())
  end

  def get_typeset_from_var_ast(_) do
    __MODULE__.new()
  end

  defimpl Enumerable do
    def count(type_set) do
      {:ok, MapSet.size(type_set.types)}
    end

    def member?(type_set, val) do
      {:ok, MapSet.member?(type_set.types, val)}
    end

    def slice(type_set) do
      size = MapSet.size(type_set.types)
      {:ok, size, &MapSet.to_list/1}
    end

    def reduce(type_set, acc, fun) do
      Enumerable.List.reduce(MapSet.to_list(type_set.types), acc, fun)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(type_set, opts) do
      opts = %Inspect.Opts{opts | charlists: :as_lists}
      concat(["TypeSet.new(", Inspect.List.inspect(MapSet.to_list(type_set.types), opts), ")"])
    end
  end
end
