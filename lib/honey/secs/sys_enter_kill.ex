defmodule Honey.Sec.SysEnterKill do
  alias Honey.{Sec}

  use Sec,
    name: "tracepoint/syscalls/sys_enter_kill",
    c_argument_type: "syscalls_enter_kill_args*",
    c_structs: [
      """
      typedef struct syscalls_enter_kill_args
      {
        /**
        * This is the tracepoint arguments of the kill functions.
        * Defined at: /sys/kernel/debug/tracing/events/syscalls/sys_enter_kill/format
        */
        long long pad;

        long syscall_nr;
        long pid;
        long sig;
      } syscalls_enter_kill_args;
      """
    ]
end
