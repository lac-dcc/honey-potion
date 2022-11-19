defmodule Honey.TranslatedCode do

  @moduledoc """
  Defines the struct that keeps the translated code and its constructor.
  """

  defstruct [:code, :return_var_name, :return_var_type]

  @doc """
  A constructor for the struct that holds the translated code with a standard value.
  The standard value, when no parameters are passed, is an empty code and a return_var_name of "0var_name_err".
  """

  def new(code \\ "", return_var_name \\ "0var_name_err") do
    %__MODULE__{code: code, return_var_name: return_var_name}
  end
end
