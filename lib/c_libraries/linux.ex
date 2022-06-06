defmodule Honey.Linux do
  defmodule Bpf do
  end
end

defmodule Honey.Syscalls_enter_kill_args do
  defstruct [:pad, :syscall_nr, :pid, :sig]
end
