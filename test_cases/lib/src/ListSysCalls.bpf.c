// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:165
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>


// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:403
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
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:448
char LICENSE[] SEC("license") = "Dual BSD/GPL";


// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:481
SEC("tracepoint/raw_syscalls/sys_enter")
int main_func(syscalls_enter_args *ctx_arg) {
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:303
StrFormatSpec str_param1;
StrFormatSpec str_param2;
StrFormatSpec str_param3;

OpResult op_result = (OpResult){0};

int zero = 0;
char(*string_pool)[STRING_POOL_SIZE] = bpf_map_lookup_elem(&string_pool_map, &zero);
if (!string_pool)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function)."};
  goto CATCH;
}

unsigned *string_pool_index = bpf_map_lookup_elem(&string_pool_index_map, &zero);
if (!string_pool_index)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function)."};
  goto CATCH;
}
*string_pool_index = 0;

__builtin_memcpy(*string_pool, "nil", 3);
__builtin_memcpy(*string_pool + 3, "false", 5);
__builtin_memcpy(*string_pool + 3 + 5, "true", 4);

Generic(*heap)[HEAP_SIZE] = bpf_map_lookup_elem(&heap_map, &zero);
if (!heap)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function)."};
  goto CATCH;
}

unsigned *heap_index = bpf_map_lookup_elem(&heap_index_map, &zero);
if (!heap_index)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function)."};
  goto CATCH;
}
*heap_index = 0;

unsigned (*tuple_pool)[TUPLE_POOL_SIZE] = bpf_map_lookup_elem(&tuple_pool_map, &zero);
if (!tuple_pool)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function)."};
  goto CATCH;
}

unsigned *tuple_pool_index = bpf_map_lookup_elem(&tuple_pool_index_map, &zero);
if (!tuple_pool_index)
{
  op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function)."};
  goto CATCH;
}
*tuple_pool_index = 0;

  // =============== beginning of user code ===============
  

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:380
Generic helper_var_907 = {0};
char helper_var_971[20] = "id";
getMember(&op_result, &ctx_0_, helper_var_971, &helper_var_907);
if (op_result.exception) goto CATCH

op_result.exception = 0;
Generic id_1_ = helper_var_907;

label_843:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:410
Generic helper_var_1035 = {.type = INTEGER, .value.integer = 0};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1005
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_1099 = {.type = INTEGER, .value.integer = 62};
BINARY_OPERATION(helper_var_1163, Equals, id_1_, helper_var_1099)

if (to_bool(&helper_var_1163)) {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:168

bpf_printk("Syscall of type enter_kill");
Generic helper_var_1227 = {.type = INTEGER, .value.integer = 0};

  helper_var_1035 = helper_var_1227;
} else {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1005
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_1291 = {.type = INTEGER, .value.integer = 83};
BINARY_OPERATION(helper_var_1355, Equals, id_1_, helper_var_1291)

if (to_bool(&helper_var_1355)) {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:168

bpf_printk("Syscall of type enter_mkdir");
Generic helper_var_1419 = {.type = INTEGER, .value.integer = 0};

  helper_var_1035 = helper_var_1419;
} else {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1005
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_1483 = {.type = INTEGER, .value.integer = 318};
BINARY_OPERATION(helper_var_1547, Equals, id_1_, helper_var_1483)

if (to_bool(&helper_var_1547)) {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:168

bpf_printk("Syscall of type enter_getrandom");
Generic helper_var_1611 = {.type = INTEGER, .value.integer = 0};

  helper_var_1035 = helper_var_1611;
} else {
  helper_var_1035 = (Generic){.type = ATOM, .value.string = (String){0, 2}};
}

}

}


Generic helper_var_1675 = {.type = INTEGER, .value.integer = 0};

  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_1675.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_1675.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
