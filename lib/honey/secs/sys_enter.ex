defmodule Honey.CType.Structs.Sys_enter do
  def new() do
    alias Honey.CNativeType.{Integer, Struct}

    int_type = Integer.new(32)

    # field:unsigned short common_type;    offset:0;    size:2;    signed:0;
    # field:unsigned char common_flags;    offset:2;    size:1;    signed:0;
    # field:unsigned char common_preempt_count;    offset:3;    size:1;    signed:0;
    # field:int common_pid;    offset:4;    size:4;    signed:1;

    # field:long id;    offset:8;    size:8;    signed:1;
    # field:unsigned long args[6];    offset:16;    size:48;    signed:0;

    fields = [
      common_type: int_type,
      common_flags: int_type,
      common_preempt_count: int_type,
      common_pid: int_type,

      id: int_type,
      args: int_type
    ]

    Struct.new("syscalls_enter_args", fields)
  end
end

defmodule Honey.Sec.Sys_enter do
  alias Honey.{Sec}

  struct_type = Honey.CType.Structs.Sys_enter.new()
  pointer_type = Honey.CNativeType.Pointer.new(struct_type)

  use Sec,
    name: "tracepoint/raw_syscalls/sys_enter",
    c_ctx_arg_type: pointer_type,
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
