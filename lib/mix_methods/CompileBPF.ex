defmodule CompileBPF do
  use Mix.Task

  def run(_) do
    path = Path.join(:code.priv_dir(:honey), "./../benchmarks/libs/libbpf/src/")
    System.cmd("make", [], cd: path)
  end

end
