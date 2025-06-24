defmodule ListSysCalls do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(ctx) do

    # Uncomment last 4 lines in case you want to see more types of sys_calls.
    # This file is a mixture of Cond and CtxAccess.
    # See https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/ for translation.

    id = ctx.id
    enter_kill = 62; enter_mkdir = 83; enter_getrandom = 318;
    cond do
      id == enter_kill -> Honey.BpfHelpers.bpf_printk(["Syscall of type enter_kill"])
      id == enter_mkdir -> Honey.BpfHelpers.bpf_printk(["Syscall of type enter_mkdir"])
      id == enter_getrandom -> Honey.BpfHelpers.bpf_printk(["Syscall of type enter_getrandom"])
      # true ->  #These ignored types are recursive as they are created from the process and lead to another call of itself.
      #   if !(id == 0) and !(id == 1) and !(id == 7) and !(id == 47) do
      #     Honey.BpfHelpers.bpf_printk(["Syscall of type %d", id])
      #   end
    end
    0
  end
end
