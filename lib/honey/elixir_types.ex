defmodule Honey.Type do
  defstruct c_type: nil, e_type: nil
  defguard is_type(var) when is_struct(var, Honey.ElixirType) or is_struct(var, Honey.ElixirType)

  def receive_type(type) when is_type(type) do
  end
end

defmodule Honey.ElixirType do
  @moduledoc """
  This module represents a type in the Elixir AST.
  More specifically this module keeps a struct that represents the details of a
  type for when it gets translated to C.
  """

  @derive {Inspect, optional: [:name, :struct, :function, :fields]}
  defstruct name: nil, struct: nil, function: nil, fields: nil

  def new(name) when is_atom(name) do
    %__MODULE__{name: name}
  end

  def new(name, fields) when is_atom(name) and is_list(fields) do
    %__MODULE__{name: name, fields: fields}
  end

  def merge_types(_type_list) do
    # TODO
  end

  def type_any() do
    new(:any)
  end

  def type_float() do
    new(:float)
  end

  def type_integer() do
    new(:integer)
  end

  def type_boolean() do
    new(:boolean)
  end

  def type_atom() do
    new(:atom)
  end

  def type_bitstring() do
    new(:string)
  end

  def type_binary() do
    new(:binary)
  end

  def type_void() do
    new(:void)
  end

  def type_struct(name) do
    %__MODULE__{name: name, struct: Honey.ElixirStructType.new()}
  end

  def type_function() do
    new(:function)
  end

  def type_list() do
    new(:list)
  end

  def type_tuple() do
    new(:tuple)
  end

  def type_invalid() do
    new(:invalid)
  end

  # The following types were hardcoded. That was a shortcut to present a proof of concept.
  # A better structure to modularize it is needed.

  def type_ctx() do
    new(:type_ctx)
  end
end

defmodule Honey.ElixirFunctionType do
  defstruct [:arguments, :return_type]

  def new() do
  end
end

defmodule Honey.ElixirFunctionArgument do
  defstruct [:name, :type, :optional]

  def new(name, type, optional \\ false) do
    %Honey.ElixirFunctionArgument{name: name, type: type, optional: optional}
  end
end

defmodule Honey.ElixirStructField do
  defstruct name: "", type: nil

  def new(_name, _type) do
  end
end

defmodule Honey.ElixirStructType do
  defstruct fields: []

  def new() do
    %Honey.ElixirStructType{}
  end

  def add_field(_field = %Honey.ElixirStructField{}) do
  end
end

defmodule Honey.TypeSet do
  @moduledoc """
  This module manages the information regarding the types that a variable can assume at
  a point in the code. Uses Honey.ElixirType to represent the possible types.
  """
  alias Honey.ElixirType

  import Honey.Utils, only: [is_var: 1]

  defstruct types: MapSet.new()

  def new(arr \\ [])

  def new(arr) when is_list(arr) do
    %__MODULE__{types: MapSet.new(arr)}
  end

  def new(type = %ElixirType{}) do
    %__MODULE__{types: MapSet.new([type])}
  end

  def new(typeset = %__MODULE__{}) do
    typeset
  end

  def new(mapset = %MapSet{}) do
    %__MODULE__{types: mapset}
  end

  def put_type(typeset = %__MODULE__{}, type = %ElixirType{}) do
    %__MODULE__{typeset | types: MapSet.put(typeset.types, type)}
  end

  def union(type_set_a = %__MODULE__{}, type_set_b = %__MODULE__{}) do
    MapSet.union(type_set_a.types, type_set_b.types)
    |> new()
  end

  def type_is_unique(set = %__MODULE__{}) do
    size(set) == 1
  end

  def has_type(set = %__MODULE__{}, type = %ElixirType{}) do
    MapSet.member?(set.types, type)
  end

  def has_unique_type(set = %__MODULE__{}, type = %ElixirType{}) do
    size(set) == 1 and has_type(set, type)
  end

  def is_generic?(set = %__MODULE__{}) do
    size(set) > 1 or size(set) == 0 or has_type(set, ElixirType.type_any())
  end

  def is_integer?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirType.type_integer())
  end

  def is_string?(set = %__MODULE__{}) do
    has_unique_type(set, ElixirType.type_bitstring())
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
