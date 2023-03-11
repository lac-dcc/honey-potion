defmodule Honey.Write do
  alias Honey.Directories
  alias Honey.Boilerplates

  @moduledoc """
  Contains functions used to write output files into the right directories.
  """

  @doc """
  Writes the .bpf.c output file. This is the part that we translate from elixir code.
  """ 

  def write_bpfc_file(c_code, proj_path, module_name, clang_format) do
    "Elixir." <> module_name = "#{module_name}"

    c_path =
      proj_path
      |> Path.dirname()
      |> Path.join("src/#{module_name}.bpf.c")

    {:ok, file} = File.open(c_path, [:write])
    IO.binwrite(file, c_code)
    File.close(file)

    # Optional, format the file using clang-format:
    clang_format && System.cmd(clang_format, ["-i", c_path])

    true
  end
  
  @doc """
  Prepares a generic makefile in the directory of the user, writes a generic front-end for eBPF and compiles everything.
  This uses the LibBPF located in /benchmarks/libs/
  """

  #This goes into compile and write modules.
  def compile_eBPF(proj_path, module_name) do

    userdir = proj_path |> Path.dirname()

    makedir = Path.join(:code.priv_dir(:honey), "BPF_Boilerplates/Makefile")
    File.cp_r(makedir, userdir |> Path.join("Makefile"))

    mod_name = Atom.to_string(module_name)
    mod_name = String.slice(mod_name, 7, String.length(mod_name) - 7)

    frontend = Boilerplates.generate_frontend_code(mod_name)
    File.write(userdir |> Path.join("./src/#{mod_name}.c"), frontend)

    libsdir = __ENV__.file |> Path.dirname
    libsdir = Path.absname("./../benchmarks/libs/libbpf/src", libsdir) |> Path.expand

    privdir = :code.priv_dir(:honey)

    System.cmd("make", ["TARGET := #{mod_name}", "LIBBPF_DIR := #{libsdir}", "PRIV_DIR := #{privdir}"], cd: userdir)
  end

  @doc """
  Writes all of the relevant files post-translation, which include module.c and module.bpf.c. Also makes sure write directories exist.
  """ 

  def write_ouput_files(c_code, proj_path, module_name, clang_format) do
    Directories.create_all(proj_path)
    write_bpfc_file(c_code, proj_path, module_name, clang_format)
    compile_eBPF(proj_path, module_name)
  end
end
