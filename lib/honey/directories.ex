defmodule Honey.Directories do
  @moduledoc """
  Creates directories used in the user directory and returns commonly used directories.
  """

  @doc """
  Creates the src, obj and bin directories if they don't already exist.
  """

  def create_all(env) do
    userdir = userdir(env)
    create_src(userdir)
    create_obj(userdir)
    create_bin(userdir)
  end
  
  @doc """
  Returns the directory of the lib folder where the user has his project.
  """

  def userdir(env) do
    env.file |> Path.dirname()
  end

  @doc """
  Returns the directory of the src folder of libbpf to get includes in compilation. 
  """

  def libsdir() do
    libsdir = __ENV__.file |> Path.dirname
    Path.absname("./../../benchmarks/libs/libbpf/src", libsdir) |> Path.expand
  end

  #Creates the directories of the name given in the method
  defp create_src(userdir) do
    File.mkdir_p(userdir |> Path.join("src/"))
  end

  defp create_obj(userdir) do
    File.mkdir_p(userdir |> Path.join("obj/"))
  end

  defp create_bin(userdir) do
    File.mkdir_p(userdir |> Path.join("bin/"))
  end

end
