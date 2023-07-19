defmodule Honey.Write do
  alias Honey.Directories
  alias Honey.Utils

  @moduledoc """
  Contains functions used to write output files into the right directories.
  """

  @doc """
  Writes all of the relevant files post-translation, which include module.c and module.bpf.c. Also makes sure write directories exist.
  """

  def write_ouput_files(backend_code, frontend_code, env) do
    Directories.create_all(env)
    write_backend_code(env, backend_code)
    write_frontend_code(env, frontend_code)
    write_makefile(env)
  end

  @doc """
  Writes the .bpf.c output file. This is the part that we translate from elixir code.
  """

  def write_backend_code(env, backend_code) do
    mod_name = Utils.formatted_module_name(env)
    clang_format = Utils.clang_format(env)

    backend_path = Directories.userdir(env) |> Path.join("src/#{mod_name}.bpf.c")

    {:ok, file} = File.open(backend_path, [:write])
    IO.binwrite(file, backend_code)
    File.close(file)

    # Optional, format the file using clang-format:
    clang_format && System.cmd(clang_format, ["-i", backend_path])

    true
  end

  @doc """
  Writes the frontend code into the right directory.
  """

  def write_frontend_code(env, frontend_code) do
    mod_name = Utils.formatted_module_name(env)
    userdir = Directories.userdir(env)

    File.write(userdir |> Path.join("./src/#{mod_name}.c"), frontend_code)
  end

  @doc """
  Writes a makefile into the user directory. Used to compile the bpf program later.
  """

  def write_makefile(env) do
    userdir = Directories.userdir(env)
    makedir = Path.join(:code.priv_dir(:honey), "BPF_Boilerplates/Makefile")

    File.cp_r(makedir, userdir |> Path.join("Makefile"))
  end
end
