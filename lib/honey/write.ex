defmodule Honey.Write do
  alias Honey.Directories
  alias Honey.Utils

  @moduledoc """
  Contains functions used to write output files into the right directories.
  """

  @doc """
  Writes the .bpf.c output file. This is the part that we translate from elixir code.
  """ 

  def write_backend_code(env, backend_code) do
    mod_name = Utils.module_name(env) 
    clang_format = Utils.clang_format(env)
    
    backend_path =
      env.file
      |> Path.dirname()
      |> Path.join("src/#{mod_name}.bpf.c")

    {:ok, file} = File.open(backend_path, [:write])
    IO.binwrite(file, backend_code)
    File.close(file)

    # Optional, format the file using clang-format:
    clang_format && System.cmd(clang_format, ["-i", backend_path])

    true
  end
  
  @doc """
  Prepares a generic makefile in the directory of the user, writes a generic front-end for eBPF and compiles everything.
  This uses the LibBPF located in /benchmarks/libs/
  """

  #This goes into compile and write modules.
  def write_frontend_code(env, frontend_code) do
    
    mod_name = Utils.module_name(env) 
    userdir = env.file |> Path.dirname()

    File.write(userdir |> Path.join("./src/#{mod_name}.c"), frontend_code)

  end

  def write_makefile(env) do
    userdir = env.file |> Path.dirname()

    makedir = Path.join(:code.priv_dir(:honey), "BPF_Boilerplates/Makefile")
    File.cp_r(makedir, userdir |> Path.join("Makefile"))
  end
  @doc """
  Writes all of the relevant files post-translation, which include module.c and module.bpf.c. Also makes sure write directories exist.
  """ 

  def write_ouput_files(backend_code, frontend_code, env) do
    Directories.create_all(env)
    write_backend_code(env, backend_code)
    write_frontend_code(env, frontend_code)
    write_makefile(env)
  end
end
