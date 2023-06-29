// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:165
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>


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
  

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:569
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:465
Generic helper_var_4675 = {.type = INTEGER, .value.integer = 1};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:465
Generic helper_var_4739 = {.type = INTEGER, .value.integer = 2};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:465
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:949
unsigned len_helper_var_4867 = 12;
unsigned end_helper_var_4867 = *string_pool_index + len_helper_var_4867 - 1;
if(end_helper_var_4867 + 1 >= STRING_POOL_SIZE) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
  goto CATCH;
}

if(*string_pool_index < STRING_POOL_SIZE - len_helper_var_4867) {
  __builtin_memcpy(&(*string_pool)[*string_pool_index], "some string", len_helper_var_4867);
}

Generic helper_var_4803 = {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = end_helper_var_4867}};
*string_pool_index = end_helper_var_4867 + 1;

Generic helper_var_4931 = {.type = INTEGER, .value.integer = 4};
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_4803;
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
  (*heap)[(*heap_index)+1] = helper_var_4931;
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

Generic helper_var_4995 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};

if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_4739;
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
  (*heap)[(*heap_index)+1] = helper_var_4995;
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

Generic helper_var_5059 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};

if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_4675;
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
  (*heap)[(*heap_index)+1] = helper_var_5059;
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

Generic helper_var_5123 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};

op_result.exception = 0;
if(helper_var_5123.type != TUPLE){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic helper_var_5187;
if(helper_var_5123.value.tuple.start + 0 < TUPLE_POOL_SIZE && helper_var_5123.value.tuple.start + 0>= 0) {
  unsigned helper_var_5251 = *((*tuple_pool)+(helper_var_5123.value.tuple.start + 0));
  if(helper_var_5251 < HEAP_SIZE && helper_var_5251 >= 0) {
    helper_var_5187 = *(*(heap)+(helper_var_5251));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5187.type != INTEGER || 1 != helper_var_5187.value.integer) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic helper_var_5315;
if(helper_var_5123.value.tuple.start + 1 < TUPLE_POOL_SIZE && helper_var_5123.value.tuple.start + 1>= 0) {
  unsigned helper_var_5379 = *((*tuple_pool)+(helper_var_5123.value.tuple.start + 1));
  if(helper_var_5379 < HEAP_SIZE && helper_var_5379 >= 0) {
    helper_var_5315 = *(*(heap)+(helper_var_5379));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5315.type != TUPLE){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic helper_var_5443;
if(helper_var_5315.value.tuple.start + 0 < TUPLE_POOL_SIZE && helper_var_5315.value.tuple.start + 0>= 0) {
  unsigned helper_var_5507 = *((*tuple_pool)+(helper_var_5315.value.tuple.start + 0));
  if(helper_var_5507 < HEAP_SIZE && helper_var_5507 >= 0) {
    helper_var_5443 = *(*(heap)+(helper_var_5507));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5443.type != INTEGER || 2 != helper_var_5443.value.integer) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic helper_var_5571;
if(helper_var_5315.value.tuple.start + 1 < TUPLE_POOL_SIZE && helper_var_5315.value.tuple.start + 1>= 0) {
  unsigned helper_var_5635 = *((*tuple_pool)+(helper_var_5315.value.tuple.start + 1));
  if(helper_var_5635 < HEAP_SIZE && helper_var_5635 >= 0) {
    helper_var_5571 = *(*(heap)+(helper_var_5635));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5571.type != TUPLE){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic helper_var_5699;
if(helper_var_5571.value.tuple.start + 0 < TUPLE_POOL_SIZE && helper_var_5571.value.tuple.start + 0>= 0) {
  unsigned helper_var_5763 = *((*tuple_pool)+(helper_var_5571.value.tuple.start + 0));
  if(helper_var_5763 < HEAP_SIZE && helper_var_5763 >= 0) {
    helper_var_5699 = *(*(heap)+(helper_var_5763));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5699.type != STRING) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}

String helper_var_5827 = helper_var_5699.value.string;
if(11 != (helper_var_5827.end - helper_var_5827.start)){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_4611;
}
if(helper_var_5827.start < STRING_POOL_SIZE - 0 && helper_var_5827.start >= 0) {
  if('s' != *((*string_pool)+(helper_var_5827.start + 0))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 1 && helper_var_5827.start >= 0) {
  if('o' != *((*string_pool)+(helper_var_5827.start + 1))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 2 && helper_var_5827.start >= 0) {
  if('m' != *((*string_pool)+(helper_var_5827.start + 2))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 3 && helper_var_5827.start >= 0) {
  if('e' != *((*string_pool)+(helper_var_5827.start + 3))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 4 && helper_var_5827.start >= 0) {
  if(' ' != *((*string_pool)+(helper_var_5827.start + 4))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 5 && helper_var_5827.start >= 0) {
  if('s' != *((*string_pool)+(helper_var_5827.start + 5))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 6 && helper_var_5827.start >= 0) {
  if('t' != *((*string_pool)+(helper_var_5827.start + 6))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 7 && helper_var_5827.start >= 0) {
  if('r' != *((*string_pool)+(helper_var_5827.start + 7))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 8 && helper_var_5827.start >= 0) {
  if('i' != *((*string_pool)+(helper_var_5827.start + 8))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 9 && helper_var_5827.start >= 0) {
  if('n' != *((*string_pool)+(helper_var_5827.start + 9))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
if(helper_var_5827.start < STRING_POOL_SIZE - 10 && helper_var_5827.start >= 0) {
  if('g' != *((*string_pool)+(helper_var_5827.start + 10))) {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_4611;
  }
}
Generic helper_var_5891;
if(helper_var_5571.value.tuple.start + 1 < TUPLE_POOL_SIZE && helper_var_5571.value.tuple.start + 1>= 0) {
  unsigned helper_var_5955 = *((*tuple_pool)+(helper_var_5571.value.tuple.start + 1));
  if(helper_var_5955 < HEAP_SIZE && helper_var_5955 >= 0) {
    helper_var_5891 = *(*(heap)+(helper_var_5955));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_4611;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_4611;
}
Generic x_1_ = helper_var_5891;

label_4611:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:170

bpf_printk("x: %d", x_1_.value.integer);
Generic helper_var_6019 = {.type = INTEGER, .value.integer = 0};


  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_6019.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_6019.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
