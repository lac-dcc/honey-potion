defmodule CompileBPF do
  use Mix.Task

  def run(_) do
    # This was used when we compiled libbpf ourselves. Now it is not needed.
    # Left here in case it's needed again as a reference.
    #path = Path.join(File.cwd!(), "benchmarks/libs/libbpf/src/")
    #System.cmd("make", [], cd: path)
  end
end
