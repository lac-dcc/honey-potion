defmodule Honey.CType.Structs.Sys_enter_write do
  def new() do
    alias Honey.CNativeType.{Integer, Struct}

    int_type = Integer.new(32)

    # field:unsigned short common_type;    offset:0;    size:2;    signed:0;
    # field:unsigned char common_flags;    offset:2;    size:1;    signed:0;
    # field:unsigned char common_preempt_count;    offset:3;    size:1;    signed:0;
    # field:int common_pid;    offset:4;    size:4;    signed:1;

    # field:int __syscall_nr;    offset:8;    size:4;    signed:1;
    # field:unsigned int fd;    offset:16;    size:8;    signed:0;
    # field:const char * buf;    offset:24;    size:8;    signed:0;
    # field:size_t count;    offset:32;    size:8;    signed:0;

    fields = [
      common_type: int_type,
      common_flags: int_type,
      common_preempt_count: int_type,
      common_pid: int_type,

      __syscall_nr: int_type,
      fd: int_type,
      buf: int_type,
      count: int_type
    ]

    Struct.new("syscalls_enter_write_args", fields)
  end
end

defmodule Honey.Sec.Sys_enter_write do
  alias Honey.{Sec}

  struct_type = Honey.CType.Structs.Sys_enter_write.new()
  pointer_type = Honey.CNativeType.Pointer.new(struct_type)

  use Sec,
    name: "tracepoint/syscalls/sys_enter_write",
    c_ctx_arg_type: pointer_type,
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
