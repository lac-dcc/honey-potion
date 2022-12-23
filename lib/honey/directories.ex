defmodule Honey.Directories do
  @moduledoc """
  Creates directories used in the user directory.
  """

  @doc """
  Creates the src, obj and bin directories if they don't already exist.
  """

  def create_all(exdir) do
    userdir = exdir |> Path.dirname()
    create_src(userdir)
    create_obj(userdir)
    create_bin(userdir)
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
