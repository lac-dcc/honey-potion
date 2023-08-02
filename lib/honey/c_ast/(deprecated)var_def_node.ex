# defmodule Honey.CAst.VarDefNode do
#   defstruct lhs: nil, rhs: nil

#   alias Honey.CAst
#   alias CAst.{VarDefNode}

#   defimpl CAst do
#     def to_str(_self) do
#       "VarDefNode"
#     end
#   end

#   def new(lhs, rhs) do
#     %VarDefNode{lhs: lhs, rhs: rhs}
#   end
# end
