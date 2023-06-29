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
Generic helper_var_71 = {.type = INTEGER, .value.integer = 1};
op_result.exception = 0;
Generic x_0_ = helper_var_71;

label_7:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:515

Generic helper_var_199;
op_result.exception = 0;
if(x_0_.type != STRING) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_263;
}

String helper_var_391 = x_0_.value.string;
if(3 != (helper_var_391.end - helper_var_391.start)){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_263;
}
if(helper_var_391.start < STRING_POOL_SIZE - 0 && helper_var_391.start >= 0) {
  if('s' != *((*string_pool)+(helper_var_391.start + 0))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_263;
  }
}
if(helper_var_391.start < STRING_POOL_SIZE - 1 && helper_var_391.start >= 0) {
  if('t' != *((*string_pool)+(helper_var_391.start + 1))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_263;
  }
}
if(helper_var_391.start < STRING_POOL_SIZE - 2 && helper_var_391.start >= 0) {
  if('r' != *((*string_pool)+(helper_var_391.start + 2))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_263;
  }
}

label_263:
if(op_result.exception == 0) {
  Generic helper_var_327 = {.type = INTEGER, .value.integer = 0};
  helper_var_199 = helper_var_327;
} else {
  op_result.exception = 0;
if(x_0_.type != ATOM || x_0_.value.string.start != 0 ) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_455;
}

label_455:
if(op_result.exception == 0) {
  Generic helper_var_519 = {.type = INTEGER, .value.integer = 0};
  helper_var_199 = helper_var_519;
} else {
  op_result.exception = 0;
if(x_0_.type != ATOM || x_0_.value.string.start != 3 ) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_583;
}

label_583:
if(op_result.exception == 0) {
  Generic helper_var_647 = {.type = INTEGER, .value.integer = 0};
  helper_var_199 = helper_var_647;
} else {
  op_result.exception = 0;
if(x_0_.type != ATOM || x_0_.value.string.start != 8 ) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_711;
}

label_711:
if(op_result.exception == 0) {
  Generic helper_var_775 = {.type = INTEGER, .value.integer = 1};
  helper_var_199 = helper_var_775;
} else {
  op_result.exception = 0;

label_839:
if(op_result.exception == 0) {
  // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_903 = {.type = INTEGER, .value.integer = 1};
BINARY_OPERATION(helper_var_967, Sum, x_0_, helper_var_903)

  helper_var_199 = helper_var_967;
} else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
  goto CATCH;

}

}

}

}

}


op_result.exception = 0;
Generic return_1_ = helper_var_199;

label_135:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:168

bpf_printk("Result: %d", return_1_.value.integer);
Generic helper_var_1031 = {.type = INTEGER, .value.integer = 0};


  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_1031.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_1031.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
