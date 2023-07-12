defmodule Honey.FunctionData do
  defstruct [:name, :arguments, :return_type]

  def new(name, arguments, return_type) do
    %Honey.FunctionData{name: name, arguments: arguments, return_type: return_type}
  end
end
