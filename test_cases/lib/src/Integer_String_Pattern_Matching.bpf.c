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
  

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:569
Generic helper_var_3720 = {.type = INTEGER, .value.integer = 1};
op_result.exception = 0;
if(helper_var_3720.type != INTEGER || 1 != helper_var_3720.value.integer) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_3656;
}

label_3656:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:569
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:949
unsigned len_helper_var_3912 = 4;
unsigned end_helper_var_3912 = *string_pool_index + len_helper_var_3912 - 1;
if(end_helper_var_3912 + 1 >= STRING_POOL_SIZE) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
  goto CATCH;
}

if(*string_pool_index < STRING_POOL_SIZE - len_helper_var_3912) {
  __builtin_memcpy(&(*string_pool)[*string_pool_index], "foo", len_helper_var_3912);
}

Generic helper_var_3848 = {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = end_helper_var_3912}};
*string_pool_index = end_helper_var_3912 + 1;

op_result.exception = 0;
if(helper_var_3848.type != STRING) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_3784;
}

String helper_var_3976 = helper_var_3848.value.string;
if(3 != (helper_var_3976.end - helper_var_3976.start)){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_3784;
}
if(helper_var_3976.start < STRING_POOL_SIZE - 0 && helper_var_3976.start >= 0) {
  if('f' != *((*string_pool)+(helper_var_3976.start + 0))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_3784;
  }
}
if(helper_var_3976.start < STRING_POOL_SIZE - 1 && helper_var_3976.start >= 0) {
  if('o' != *((*string_pool)+(helper_var_3976.start + 1))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_3784;
  }
}
if(helper_var_3976.start < STRING_POOL_SIZE - 2 && helper_var_3976.start >= 0) {
  if('o' != *((*string_pool)+(helper_var_3976.start + 2))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_3784;
  }
}

label_3784:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:170

bpf_printk("Success");
Generic helper_var_4040 = {.type = INTEGER, .value.integer = 0};

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:569
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:949
unsigned len_helper_var_4232 = 4;
unsigned end_helper_var_4232 = *string_pool_index + len_helper_var_4232 - 1;
if(end_helper_var_4232 + 1 >= STRING_POOL_SIZE) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
  goto CATCH;
}

if(*string_pool_index < STRING_POOL_SIZE - len_helper_var_4232) {
  __builtin_memcpy(&(*string_pool)[*string_pool_index], "foo", len_helper_var_4232);
}

Generic helper_var_4168 = {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = end_helper_var_4232}};
*string_pool_index = end_helper_var_4232 + 1;

op_result.exception = 0;
if(helper_var_4168.type != STRING) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4104;
}

String helper_var_4296 = helper_var_4168.value.string;
if(3 != (helper_var_4296.end - helper_var_4296.start)){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4104;
}
if(helper_var_4296.start < STRING_POOL_SIZE - 0 && helper_var_4296.start >= 0) {
  if('b' != *((*string_pool)+(helper_var_4296.start + 0))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4104;
  }
}
if(helper_var_4296.start < STRING_POOL_SIZE - 1 && helper_var_4296.start >= 0) {
  if('a' != *((*string_pool)+(helper_var_4296.start + 1))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4104;
  }
}
if(helper_var_4296.start < STRING_POOL_SIZE - 2 && helper_var_4296.start >= 0) {
  if('r' != *((*string_pool)+(helper_var_4296.start + 2))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4104;
  }
}

label_4104:
if(op_result.exception == 1) {
  goto CATCH;
}


  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_4168.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_4168.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
