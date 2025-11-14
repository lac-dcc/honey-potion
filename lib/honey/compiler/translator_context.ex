defmodule Honey.Compiler.TranslatorContext do
  defstruct [:maps]

  def new(maps) do
    %__MODULE__{maps: maps}
  end
end