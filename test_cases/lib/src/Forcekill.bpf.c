// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:165
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>

struct {
  __uint(max_entries, 64);
__uint(type, BPF_MAP_TYPE_HASH);
  __uint(key_size, sizeof(long));
  __uint(value_size, sizeof(Generic));
} kills SEC(".maps");

// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:387
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
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:448
char LICENSE[] SEC("license") = "Dual BSD/GPL";


// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:481
SEC("tracepoint/syscalls/sys_enter_kill")
int main_func(syscalls_enter_kill_args *ctx_arg) {
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
Generic helper_var_139 = {0};
char helper_var_203[20] = "sig";
getMember(&op_result, &ctx_0_, helper_var_203, &helper_var_139);
if (op_result.exception) goto CATCH

op_result.exception = 0;
Generic sig_1_ = helper_var_139;

label_75:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:380
Generic helper_var_331 = {0};
char helper_var_395[20] = "pid";
getMember(&op_result, &ctx_0_, helper_var_395, &helper_var_331);
if (op_result.exception) goto CATCH

op_result.exception = 0;
Generic pid_2_ = helper_var_331;

label_267:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:515
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_459 = {.type = INTEGER, .value.integer = 9};
BINARY_OPERATION(helper_var_523, Equals, sig_1_, helper_var_459)

Generic helper_var_587;
op_result.exception = 0;
if(helper_var_523.type != ATOM || helper_var_523.value.string.start != 3 ) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_651;
}

label_651:
if(op_result.exception == 0) {
  Generic helper_var_715 = ATOM_NIL;
  helper_var_587 = helper_var_715;
} else {
  op_result.exception = 0;
if(helper_var_523.type != ATOM || helper_var_523.value.string.start != 8 ) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_779;
}

label_779:
if(op_result.exception == 0) {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:339

Generic helper_var_1092 = {.type = INTEGER, .value.integer = 1};
if(pid_2_.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
  goto CATCH;
}
int helper_var_1156 = bpf_map_update_elem(&kills, &(pid_2_.value.integer), &helper_var_1092, BPF_NOEXIST);
Generic helper_var_1220 = (Generic){.type = INTEGER, .value.integer = helper_var_1156};

  helper_var_587 = helper_var_1220;
} else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
  goto CATCH;

}

}


Generic helper_var_1284 = {.type = INTEGER, .value.integer = 0};

  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_1284.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_1284.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
