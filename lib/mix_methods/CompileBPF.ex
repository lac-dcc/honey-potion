defmodule CompileBPF do
  use Mix.Task

  def run(_) do
    path = Path.join(File.cwd!(), "benchmarks/libs/libbpf/src/")
    System.cmd("make", ["OBJDIR=build", "DESTDIR=root", "install"], cd: path)
  end
end
