defmodule Honey.Sec.SysEnterWrite do
  alias Honey.{Sec}

  use Sec,
    name: "tracepoint/syscalls/sys_enter_write",
    c_argument_type: "syscalls_enter_write_args*",
    c_structs: [
      """
      typedef struct syscalls_enter_write_args
      {
        /**
         * This is the tracepoint arguments.
         * Defined at: /sys/kernel/debug/tracing/events/syscalls/sys_enter_write/format
         */
         unsigned short common_type;
         unsigned char common_flags;
         unsigned char common_preempt_count;
         int common_pid;
         int __syscall_nr;
         unsigned int fd;
         const char * buf;
         size_t count;
      } syscalls_enter_write_args;
      """
    ]
end
