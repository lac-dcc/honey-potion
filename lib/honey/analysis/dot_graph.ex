defmodule Honey.Analysis.DotGraph do
  alias Honey.Utils.Core
  import Honey.Utils.Core, only: [is_var: 1, var_to_key: 1]
  alias Honey.Utils.Directories

  #Relies on StaticAnalysis to use sv (scoped variables) and dv (dead variables).
  def variable_interference_graph(ast, env) do
    mod_name = Core.module_name(env)

    Directories.create_dot(Directories.userdir(env))
    dot_dir = Directories.userdir(env) |> Path.join("dot/#{mod_name}_var_interference.dot")

    dot_graph = "strict graph { \n"

    {_, variable_interferences} = Macro.prewalk(ast, %{}, &map_variables_to_interference/2)

    dot_graph = dot_graph <>
    Enum.reduce(variable_interferences, "" , fn {var, interferences}, acc ->
      acc <>
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

  defp map_variables_to_interference(ast = {_, meta, _}, acc) when is_var(ast) do
    var = var_to_key(ast)

    IO.puts("Analyzing variable #{var}")
    in_scope_vars = Keyword.get(meta, :sv, MapSet.new())
    in_scope_vars = MapSet.delete(in_scope_vars, var)
    dead_vars = Keyword.get(meta, :dv, MapSet.new())

    isv = MapSet.to_list(in_scope_vars)
    isv = Enum.map(isv, &Atom.to_string(&1))
    dvs = MapSet.to_list(dead_vars)
    dvs = Enum.map(dvs, &Atom.to_string(&1))

    IO.puts("With sv #{isv}")
    IO.puts("With dv #{dvs}")

    interference_vars = MapSet.difference(in_scope_vars, dead_vars)

    acc = Map.update(acc, var, MapSet.new(), fn set -> MapSet.union(set, interference_vars) end)
    {ast, acc}
  end

  defp map_variables_to_interference(ast, acc) do
    {ast, acc}
  end

  
end
