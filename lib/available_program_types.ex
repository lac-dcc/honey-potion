defmodule Honey.AvailableProgramTypes do
  alias Honey.{Boilerplates.AddOn, Struct}
  import Honey.Utils, only: [gen: 1]

  def generate_available_types do
    %{
      "tracepoint/syscalls/sys_enter_kill" => %ProgramType{
        sec: "tracepoint/syscalls/sys_enter_kill",
        main_arguments_types: ["struct syscalls_enter_kill_args*"],
        add_on: %AddOn{
          code_before_structs:
            gen("""
            struct syscalls_enter_kill_args
            {
              /**
              * This is the tracepoint arguments of the kill functions.
              * Defined at: /sys/kernel/debug/tracing/events/syscalls/sys_enter_kill/format
              */
              long long pad;

              long syscall_nr;
              long pid;
              long sig;
            };
            """),
          structs: [
            %Struct{
              name: "Syscalls_enter_kill_args",
              fields: ["pad", "syscall_nr", "pid", "sig"]
            }
          ],
          main_code:
            gen("""
            Generic converted_arg_1 = {.type = TYPE_Syscalls_enter_kill_args, .value.value_Syscalls_enter_kill_args = {(*heap_index)++, (*heap_index)++, (*heap_index)++, (*heap_index)++}};
            if (converted_arg_1.value.value_Syscalls_enter_kill_args.idx_pad < HEAP_SIZE)
            {
              // (*heap)[converted_arg_1.value.value_Syscalls_enter_kill_args.idx_pad] = (Generic){.type = INTEGER, .value.integer = arg_1->pad};
            }
            if (converted_arg_1.value.value_Syscalls_enter_kill_args.idx_syscall_nr < HEAP_SIZE)
            {
              (*heap)[converted_arg_1.value.value_Syscalls_enter_kill_args.idx_syscall_nr] = (Generic){.type = INTEGER, .value.integer = arg_1->syscall_nr};
            }
            if (converted_arg_1.value.value_Syscalls_enter_kill_args.idx_pid < HEAP_SIZE)
            {
              (*heap)[converted_arg_1.value.value_Syscalls_enter_kill_args.idx_pid] = (Generic){.type = INTEGER, .value.integer = arg_1->pid};
            }
            if (converted_arg_1.value.value_Syscalls_enter_kill_args.idx_sig < HEAP_SIZE)
            {
              (*heap)[converted_arg_1.value.value_Syscalls_enter_kill_args.idx_sig] = (Generic){.type = INTEGER, .value.integer = arg_1->sig};
            }
            """)
        }
      }
    }
  end
end
