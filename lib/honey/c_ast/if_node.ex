defmodule Honey.CAst.IfNode do
  defstruct condition: nil, if_block: nil, else_block: nil

  alias Honey.CAst.{BlockNode, IfNode, Utils}
  alias Honey.CValue

  import Utils, only: [indent: 1]

  defimpl CValue do
  alias Honey.CAst.BlockNode
    def get_c_representation(self, _options \\ []) do
      cond_c = CValue.get_c_representation(self.condition)
      if_block_c = CValue.get_c_representation(self.if_block)

      else_c =
        if(self.else_block) do
          else_block_c = CValue.get_c_representation(self.else_block)

          """
          else {
            #{indent(else_block_c)}
          }\
          """
        else
          ""
        end

      """
      if (#{cond_c}) {
        #{indent(if_block_c)}
      } #{else_c}\
      """
    end

    def get_type(self) do
      # TODO: add the right type... I'm only considering the condition one to test purposes
      CValue.get_type(self.if_block)
    end
  end

  def new(condition, if_block = %BlockNode{}, else_block = %BlockNode{}) do
    %IfNode{condition: condition, if_block: if_block, else_block: else_block}
  end

  def new(condition, if_block = %BlockNode{}) do
    %IfNode{condition: condition, if_block: if_block, else_block: nil}
  end
end
