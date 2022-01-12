defmodule GraphUtils do
  def dfs_visit(graph, u, contains_cycle \\ false) do
    if contains_cycle do
      {graph, contains_cycle}
    else
      u = put_in(u.dfs_color, "GREY")
      graph = CallGraph.replace_node(graph, u)

      {graph, contains_cycle} =
        Enum.reduce(u.adjs, {graph, contains_cycle}, fn v_name, {graph, contains_cycle} ->
          v = CallGraph.get_node_by_name(graph, v_name)

          if v.dfs_color == "WHITE" do
            dfs_visit(graph, v, contains_cycle)
          else
            if v.dfs_color == "GREY" do
              {graph, true}
            else
              {graph, contains_cycle}
            end
          end
        end)

      u = CallGraph.get_node_by_name(graph, u.fun.name)
      u = put_in(u.dfs_color, "BLACK")
      graph = CallGraph.replace_node(graph, u)

      {graph, contains_cycle}
    end
  end

  def dfs(graph) do
    Enum.reduce(graph.nodes, {graph, false}, fn u, {graph, contains_cycle} ->
      if contains_cycle do
        {graph, contains_cycle}
      else
        if u.dfs_color == "WHITE" do
          dfs_visit(graph, u)
        else
          {graph, contains_cycle}
        end
      end
    end)
  end

  def contains_cycle?(graph) do
    new_nodes =
      Enum.map(graph.nodes, fn node ->
        put_in(node.dfs_color, "WHITE")
      end)

    graph = put_in(graph.nodes, new_nodes)

    {_, cycle} = dfs(graph)
    cycle
  end
end

defmodule Fun do
  defstruct [:name, :definition]

  def new(name, definition) do
    %Fun{name: name, definition: definition}
  end
end

defmodule CGNode do
  defstruct fun: nil, adjs: [], dfs_color: "WHITE"

  def new(fun) do
    %CGNode{%CGNode{} | fun: fun}
  end

  def add_adj(node, adj_name) do
    %CGNode{node | adjs: [adj_name | node.adjs]}
  end
end

defmodule CallGraph do
  defstruct nodes: []

  def new() do
    %CallGraph{}
  end

  def add_function(graph, function) do
    # Check if function exists
    if not Enum.any?(graph.nodes, fn node -> node.fun.name == function.name end) do
      node = CGNode.new(function)
      put_in(graph.nodes, graph.nodes ++ [node])
    else
      graph
    end
  end

  def replace_node(graph, node) do
    new_nodes =
      graph.nodes
      |> Enum.map(fn u ->
        if u.fun.name == node.fun.name do
          node
        else
          u
        end
      end)

    put_in(graph.nodes, new_nodes)
  end

  def get_node_by_name(graph, fun_name) do
    Enum.find(graph.nodes, nil, fn node ->
      node.fun.name == fun_name
    end)
  end

  def connect_functions(graph, f1_name, f2_name) do
    if get_node_by_name(graph, f2_name) != nil do
      f1_node = get_node_by_name(graph, f1_name)
      f1_node = put_in(f1_node.adjs, f1_node.adjs ++ [f2_name])

      replace_node(graph, f1_node)
    else
      graph
    end
  end

  def print(graph) do
    Enum.each(graph.nodes, fn node ->
      node.fun.name <> " -> " <> Enum.join(node.adjs, ", ")
      |> IO.puts()
    end)

    graph
  end

  def is_recursive?(graph) do
    GraphUtils.contains_cycle?(graph)
  end

  # A simple test to check if CallGraph is working properly
  # You can call it with CallGraph.Test.start()
  defmodule Test do
    def start() do
      f1 = Fun.new("function_name_1", {:an, :ast, :here})
      f2 = Fun.new("function_name_2", {:an, :ast, :here})
      f3 = Fun.new("function_name_3", {:an, :ast, :here})
      f4 = Fun.new("function_name_4", {:an, :ast, :here})
      f5 = Fun.new("function_name_5", {:an, :ast, :here})
      f6 = Fun.new("function_name_6", {:an, :ast, :here})
      f7 = Fun.new("function_name_7", {:an, :ast, :here})
      f8 = Fun.new("function_name_8", {:an, :ast, :here})
      f9 = Fun.new("function_name_9", {:an, :ast, :here})

      CallGraph.new()
      |> CallGraph.add_function(f1)
      |> CallGraph.add_function(f2)
      |> CallGraph.add_function(f3)
      |> CallGraph.add_function(f4)
      |> CallGraph.add_function(f5)
      |> CallGraph.add_function(f6)
      |> CallGraph.add_function(f7)
      |> CallGraph.add_function(f8)
      |> CallGraph.add_function(f9)

      |> CallGraph.connect_functions("function_name_1", "function_name_2")
      |> CallGraph.connect_functions("function_name_1", "function_name_3")
      |> CallGraph.connect_functions("function_name_1", "function_name_5")
      |> CallGraph.connect_functions("function_name_6", "function_name_1")
      |> CallGraph.connect_functions("function_name_6", "function_name_2")
      |> CallGraph.connect_functions("function_name_3", "function_name_4")
      |> CallGraph.connect_functions("function_name_4", "function_name_5")

      |> CallGraph.print()
      |> CallGraph.is_recursive?()
      |> IO.puts()
    end
  end
end
