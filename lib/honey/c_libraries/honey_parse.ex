defmodule Honey.Parse do
  alias Honey.{ElixirType, ElixirFunctionArgument, FunctionData, CLibrary}
  use CLibrary

  def parse_ethhdr(_binary) do
    arguments = [ElixirFunctionArgument.new("binary", ElixirType.type_binary)]
    return_type = ElixirType.new(:ethhdr_pointer)
    FunctionData.new("parse_ethhdr", arguments, return_type)
  end
end
