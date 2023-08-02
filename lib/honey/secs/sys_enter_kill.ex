defmodule Honey.CType.Structs.Sys_enter_kill do
  def new() do
    alias Honey.CNativeType.{Integer, Struct}

    int_type = Integer.new(32)

    # field:unsigned short common_type;	offset:0;	size:2;	signed:0;
    # field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
    # field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
    # field:int common_pid;	offset:4;	size:4;	signed:1;

    # field:int __syscall_nr;	offset:8;	size:4;	signed:1;
    # field:pid_t pid;	offset:16;	size:8;	signed:0;
    # field:int sig;	offset:24;	size:8;	signed:0;

    fields = [
      common_type: int_type,
      common_flags: int_type,
      common_preempt_count: int_type,
      common_pid: int_type,

      __syscall_nr: int_type,
      pid: int_type,
      sig: int_type
    ]

    Struct.new("syscalls_enter_kill_args", fields)
  end
end

defmodule Honey.Sec.Sys_enter_kill do
  alias Honey.{Sec}

  struct_type = Honey.CType.Structs.Sys_enter_kill.new()
  # pointer_type = Honey.CNativeType.Pointer.new(struct_type)

  use Sec,
    name: "tracepoint/syscalls/sys_enter_kill",
    c_ctx_arg_type: struct_type,
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
