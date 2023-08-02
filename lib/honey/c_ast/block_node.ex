defmodule Honey.CAst.BlockNode do
  defstruct nodes: []

  alias Honey.CAst
  alias CAst.{BlockNode, Utils}
  alias Honey.CValue

  defimpl CValue do
    def get_c_representation(self, options) do
      indent_level = Keyword.get(options, :indent_level, 0)

      c_insts = Enum.map(self.nodes, &Honey.CValue.get_c_representation/1)
      |> Enum.join(";\n")

      c_insts <> ";"
      |> Utils.indent(indent_level)
    end

    def get_type(self) do
      [node] = Enum.take(self.nodes, -1)
      CValue.get_type(node)
    end
  end

  def add_node(block_node = %BlockNode{}, node) when is_struct(node) do
    # TODO: Check if it's a valid node
    %BlockNode{block_node | nodes: block_node.nodes ++ [node]}
  end

  def new() do
    %BlockNode{}
  end
end
