defmodule Honey.TranslatedCode do
  defstruct [:code, :return_var_name, :return_var_type]

  def new(code \\ "", return_var_name \\ "0var_name_err") do
    %__MODULE__{code: code, return_var_name: return_var_name}
  end
end
