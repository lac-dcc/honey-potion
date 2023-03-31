defmodule Honey.Compiler do
  alias Honey.Directories
  alias Honey.Utils

  @moduledoc """
  Contains functions used to compile the generated code. 
  """

  @doc """
  Compiles the files located in userdir/src using a pre-defined Makefile that was added in write module.
  """

  def compile_bpf(env) do 
    mod_name = Utils.module_name(env)

    userdir = Directories.userdir(env)
    libsdir = Directories.libsdir()
    privdir = :code.priv_dir(:honey)

    System.cmd("make", ["TARGET := #{mod_name}", "LIBBPF_DIR := #{libsdir}", "PRIV_DIR := #{privdir}"], cd: userdir)
  end
end
