// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:165
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>

struct {
  __uint(max_entries, 335);


__uint(type, BPF_MAP_TYPE_ARRAY);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(Generic));
} Count_Sys_Calls_Invoked SEC(".maps");

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
Generic helper_var_195 = {0};
char helper_var_259[20] = "id";
getMember(&op_result, &ctx_0_, helper_var_259, &helper_var_195);
if (op_result.exception) goto CATCH

op_result.exception = 0;
Generic id_1_ = helper_var_195;

label_131:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:237

if(id_1_.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
  goto CATCH;
}
Generic *helper_var_515 = bpf_map_lookup_elem(&Count_Sys_Calls_Invoked, &(id_1_.value.integer));

Generic helper_var_579 = (Generic){.type = INTEGER, .value.integer = 0};

Generic helper_var_387 = helper_var_515 ? ATOM_TRUE : ATOM_FALSE;
Generic helper_var_451 = (Generic){0};
if(!helper_var_515) {
  // helper_var_451 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Count_Sys_Calls_Invoked'."};
  goto CATCH;
} else {
  helper_var_451 = *helper_var_515;
  helper_var_451.type = helper_var_451.type == INVALID_TYPE ? INTEGER : helper_var_451.type;
}
/* // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1037
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_387;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
if(*tuple_pool_index < (TUPLE_POOL_SIZE-0)) {
  (*tuple_pool)[(*tuple_pool_index)+0] = (*heap_index)+0;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
if(*heap_index < (HEAP_SIZE-1)) {
  (*heap)[(*heap_index)+1] = helper_var_451;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
if(*tuple_pool_index < (TUPLE_POOL_SIZE-1)) {
  (*tuple_pool)[(*tuple_pool_index)+1] = (*heap_index)+1;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
*heap_index += 2;
*tuple_pool_index += 2;

Generic helper_var_643 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
 */

op_result.exception = 0;
Generic id_count_2_ = helper_var_451;

label_323:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:339

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_707 = {.type = INTEGER, .value.integer = 1};
BINARY_OPERATION(helper_var_771, Sum, id_count_2_, helper_var_707)

if(id_1_.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
  goto CATCH;
}
int helper_var_835 = bpf_map_update_elem(&Count_Sys_Calls_Invoked, &(id_1_.value.integer), &helper_var_771, BPF_ANY);
Generic helper_var_899 = (Generic){.type = INTEGER, .value.integer = helper_var_835};

Generic helper_var_963 = {.type = INTEGER, .value.integer = 0};

  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_963.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_963.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
