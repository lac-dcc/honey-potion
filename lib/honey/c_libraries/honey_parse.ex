defmodule Honey.Parse do
  alias Honey.{ElixirType, FunctionArgument, FunctionData, CLibrary}
  use CLibrary

  def parse_ethhdr(_binary) do
    arguments = [FunctionArgument.new("binary", ElixirType.type_binary)]
    return_type = ElixirType.new(:ethhdr_pointer)
    FunctionData.new("parse_ethhdr", arguments, return_type)
  end
end
