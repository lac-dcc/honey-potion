defmodule Honey.Analysis.ElixirTypes do
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
