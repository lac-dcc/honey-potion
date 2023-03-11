defmodule Honey.Generator do
  alias Honey.Translator
  alias Honey.Boilerplates
  import Honey.Utils, only: [module_name: 1]
  @moduledoc """
  Groups the Boilerplates and Translation Modules to generate both the front-end and back-end code.
  """

  @doc """
  Generates both the front-end code and the back-end code.
  """ 
  def generate_code(env, final_ast) do 
    {target_func, target_arity} = {:main, 1}

    #This can go into Utils as ExtractEnv or into Info.
    ebpf_options = Module.get_attribute(env.module, :ebpf_options)
    #Gets values required to translate the AST to eBPF readable C.
    sections = Module.get_attribute(env.module, :sections)
    sec = Map.get(sections, {:def, target_func, target_arity})
    license = Keyword.fetch!(ebpf_options, :license)
    maps = Module.get_attribute(env.module, :ebpf_maps)
    # TODO: env.requires stores the requires in alphabetical order. This might be a problem.
    backend_code = Translator.translate("main", final_ast, sec, license, env.requires, maps)

    mod_name = module_name(env)

    frontend_code = Boilerplates.generate_frontend_code(mod_name)

    {backend_code, frontend_code}
  end

end
