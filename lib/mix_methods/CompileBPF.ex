defmodule CompileBPF do
  use Mix.Task

  def run(_) do
    path = "./benchmarks/libs/libbpf/src/"
    System.cmd("make", [], cd: path)
  end

end
