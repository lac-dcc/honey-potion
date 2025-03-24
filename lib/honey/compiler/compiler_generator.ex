defmodule Honey.Compiler.CodeGenerator do
  @moduledoc """
  Groups the Boilerplates and Translation Modules to generate both the front-end and back-end code.
  """
  alias Honey.Codegen.Boilerplates
  alias Honey.Runtime.Info
  alias Honey.Compiler.Translator

  @doc """
  Generates both the front-end code and the back-end code.
  """
  def generate_code(env, final_ast) do
    {_ebpf_options, sec, license, maps} = Info.get_backend_info(env)
    backend_code = Translator.translate("main", final_ast, sec, license, env.requires, maps)

    frontend_code = Boilerplates.generate_frontend_code(env)

    {backend_code, frontend_code}
  end
end
