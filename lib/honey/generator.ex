defmodule Honey.Generator do
  alias Honey.Translator
  alias Honey.Boilerplates
  alias Honey.Info

  @moduledoc """
  Groups the Boilerplates and Translation Modules to generate both the front-end and back-end code.
  """

  @doc """
  Generates both the front-end code and the back-end code.
  """

  def generate_code(env, final_ast) do
    {_ebpf_options, sec, license, maps} = Info.get_backend_info(env)
    backend_code = Translator.translate("main", final_ast, sec, license, maps)

    frontend_code = Boilerplates.generate_frontend_code(env)

    {backend_code, frontend_code}
  end
end
