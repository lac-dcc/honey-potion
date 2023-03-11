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
   
    userdir = env.file |> Path.dirname()
    mod_name = Utils.module_name(env)

    libsdir = __ENV__.file |> Path.dirname
    libsdir = Path.absname("./../benchmarks/libs/libbpf/src", libsdir) |> Path.expand

    privdir = :code.priv_dir(:honey)

    System.cmd("make", ["TARGET := #{mod_name}", "LIBBPF_DIR := #{libsdir}", "PRIV_DIR := #{privdir}"], cd: userdir)

  end
end
