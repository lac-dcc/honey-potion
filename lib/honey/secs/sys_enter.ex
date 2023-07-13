defmodule Honey.Sec.SysEnter do
  alias Honey.{Sec}

  use Sec,
    name: "tracepoint/raw_syscalls/sys_enter",
    c_argument_type: "syscalls_enter_args*",
    c_structs: [
      """
      typedef struct syscalls_enter_args
      {
        /**
         * This is the tracepoint arguments.
         * Defined at: /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/format
         */
          unsigned short common_type;
          unsigned char common_flags;
          unsigned char common_preempt_count;
          int common_pid;
          long id;
          unsigned long args[6];
      } syscalls_enter_args;
      """
    ]
end
