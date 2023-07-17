defmodule Honey.Info do
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
    sec_name = Map.get(sections, {:def, target_func, target_arity})
    sec_module = Honey.ExportedSecs.get_from_sec_name!(sec_name)
    license = Keyword.fetch!(ebpf_options, :license)
    maps = Module.get_attribute(env.module, :ebpf_maps)

    {ebpf_options, sec_module, license, maps}
  end

  @doc """
  Gets the AST for main and it's arguments.
  """

  def get_ast(main_def) do
    # TODO: evaluate all clauses
    {:v1, _kind, _metadata, [first_clause | _other_clauses]} = main_def
    {metadata, arguments, _guards, func_ast} = first_clause

    {metadata, arguments, func_ast}
  end

  @doc """
  Gets all of the main attributes of a map.
  """

  def get_maps_attributes(maps) do
    name = Map.get(maps, :name)
    content = Map.get(maps, :content)

    type = Map.get(content, :type)
    max_entries = Map.get(content, :max_entries)
    print = Map.get(content, :print)
    print_elem = Map.get(content, :print_elem)
    {name, type, max_entries, print, print_elem}
  end
end
