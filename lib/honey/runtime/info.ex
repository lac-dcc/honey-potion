defmodule Honey.Runtime.Info do
  @moduledoc """
  A module for getting hard/inconvenient information to the rest of the project.
  """

  @doc """
  Grabs the information used in generating the backend.
  """
  def get_backend_info(env) do
    target_func = :main
    target_arity = 1

    ebpf_options = Module.get_attribute(env.module, :ebpf_options)
    sections = Module.get_attribute(env.module, :sections)
    sec = Map.get(sections, {:def, target_func, target_arity})
    license = Keyword.fetch!(ebpf_options, :license)
    maps = Module.get_attribute(env.module, :ebpf_maps)
    # TODO: env.requires stores the requires in alphabetical order. This might be a problem.

    {ebpf_options, sec, license, maps}
  end

  @doc """
  Gets the AST for main and it's arguments.
  """
  def get_ast(main_def) do
    # TODO: evaluate all clauses
    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {_metadata, arguments, _guards, func_ast} = first_clause
    {arguments, func_ast}
  end

  @doc """
  Gets all of the main attributes of a map.
  """
  def get_maps_attributes(maps) do
    name = Map.get(maps, :name)
    content = Map.get(maps, :content)

    type = Map.get(content, :type)
    option = Map.get(content, :options)

    max_entries = Keyword.get(option, :max_entries)
    print = Keyword.get(option, :print)
    print_elem = Keyword.get(option, :print_elem)
    key_size = Keyword.get(option, :key_size, :int)
    {name, type, max_entries, print, print_elem, key_size}
  end
end
