defmodule Honey.Compiler.Pipeline do
  @moduledoc """
  Contains functions used to compile the generated code. 
  """
  alias Honey.Utils.Directories
  alias Honey.Utils.Core

  @doc """
  Compiles the files located in userdir/src using a pre-defined Makefile that was added in write module.
  """
  def compile_bpf(env) do
    mod_name = Core.module_name(env)

    userdir = Directories.userdir(env)
    libsdir = Directories.libsdir()
    privdir = :code.priv_dir(:honey)

    System.cmd(
      "make",
      ["TARGET := #{mod_name}", "LIBBPF_DIR := #{libsdir}", "PRIV_DIR := #{privdir}"],
      cd: userdir
    )
  end
end
