defmodule Honey.Analysis.DotGraph do
  alias Honey.TypeSet
  alias Honey.Utils.Core
  import Honey.Utils.Core, only: [is_var: 1, var_to_key: 1]
  alias Honey.Utils.Directories

  #Relies on StaticAnalysis to use sv (scoped variables) and dv (dead variables).
  def variable_interference_graph(ast, env) do
    mod_name = Core.module_name(env)

    Directories.create_dot(Directories.userdir(env))
    dot_dir = Directories.userdir(env) |> Path.join("dot/#{mod_name}_var_interference.dot")

    dot_graph = "strict graph { \n"

    {_, {var_to_interference, var_to_size}} = Macro.prewalk(ast, {%{},%{}}, &map_variables_to_interference_and_size/2)

    dot_graph = dot_graph <>
    Enum.reduce(var_to_interference, "", fn {var, interferences}, acc ->
      acc <>
      "#{var} [label=\"\\N Size " <> Integer.to_string(Map.get(var_to_size, var, 0)) <> "\"]\n" <>
      Enum.reduce(interferences, "", fn interference_var, acc ->
        acc <> "#{var} -- #{interference_var}\n"
      end)
    end)
    <> "}\n"

    {:ok, file} = File.open(dot_dir, [:write])
    IO.binwrite(file, dot_graph)
    File.close(file)

    # The pipeline requires the analysis modules to return the AST.
    ast
  end

  defp map_variables_to_interference_and_size(ast = {_, meta, _}, {var_to_interference, var_to_size}) when is_var(ast) do
    var = var_to_key(ast)

    #IO.puts("Analyzing variable #{var}")

    type = Keyword.get(meta, :types, TypeSet.new())

    type_size = cond do
      TypeSet.is_generic?(type) -> 12
      TypeSet.is_string?(type) -> 8
      TypeSet.is_integer?(type) -> 4
      true -> 0
    end

    in_scope_vars = Keyword.get(meta, :sv, MapSet.new())
    in_scope_vars = MapSet.delete(in_scope_vars, var)
    dead_vars = Keyword.get(meta, :dv, MapSet.new())

    #isv = MapSet.to_list(in_scope_vars)
    #isv = Enum.map(isv, &Atom.to_string(&1))
    #dvs = MapSet.to_list(dead_vars)
    #dvs = Enum.map(dvs, &Atom.to_string(&1))

    #IO.puts("With sv #{isv}")
    #IO.puts("With dv #{dvs}")

    interference_vars = MapSet.difference(in_scope_vars, dead_vars)

    var_to_interference = Map.update(var_to_interference, var, MapSet.new(), fn set -> MapSet.union(set, interference_vars) end)
    var_to_size = Map.update(var_to_size, var, type_size, fn _ -> type_size end)
    {ast, {var_to_interference, var_to_size}}
  end

  defp map_variables_to_interference_and_size(ast, acc) do
    {ast, acc}
  end
end
