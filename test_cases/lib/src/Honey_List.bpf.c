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
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:502
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:502
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:482
Generic helper_var_1607 = {.type = LIST, .value.tuple = (Tuple){.start = -1, .end = -1}};
if((*heap_index) < HEAP_SIZE && (*heap_index) >= 0) {
  (*heap)[(*heap_index)] = helper_var_1607;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
++(*heap_index);
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:639
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:465
Generic helper_var_1671 = {.type = INTEGER, .value.integer = 1};
Generic helper_var_1735 = {.type = INTEGER, .value.integer = 2};
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_1671;
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
  (*heap)[(*heap_index)+1] = helper_var_1735;
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

Generic helper_var_1799 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
if(*tuple_pool_index < TUPLE_POOL_SIZE && *tuple_pool_index >= 0) {
  (*tuple_pool)[(*tuple_pool_index)] = (*heap_index);
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
++(*tuple_pool_index);
if(*tuple_pool_index < TUPLE_POOL_SIZE && *tuple_pool_index >= 0) {
  (*tuple_pool)[(*tuple_pool_index)] = (*heap_index)-1;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
++(*tuple_pool_index);

Generic helper_var_1863 = (Generic){.type = LIST, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
  (*heap)[(*heap_index)] = helper_var_1799;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
++(*heap_index);
if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
  (*heap)[(*heap_index)] = helper_var_1863;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
++(*heap_index);
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:639
Generic helper_var_1927 = {.type = INTEGER, .value.integer = 3};if(*tuple_pool_index < TUPLE_POOL_SIZE && *tuple_pool_index >= 0) {
  (*tuple_pool)[(*tuple_pool_index)] = (*heap_index);
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
++(*tuple_pool_index);
if(*tuple_pool_index < TUPLE_POOL_SIZE && *tuple_pool_index >= 0) {
  (*tuple_pool)[(*tuple_pool_index)] = (*heap_index)-1;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
  goto CATCH;
}
++(*tuple_pool_index);

Generic helper_var_1991 = (Generic){.type = LIST, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
  (*heap)[(*heap_index)] = helper_var_1927;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
++(*heap_index);
if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
  (*heap)[(*heap_index)] = helper_var_1991;
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
  goto CATCH;
}
++(*heap_index);

op_result.exception = 0;
if(helper_var_1991.type != LIST){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}
Generic helper_var_2055;
if(helper_var_1991.value.tuple.start < TUPLE_POOL_SIZE && helper_var_1991.value.tuple.start >= 0) {
  unsigned helper_var_2119 = *((*tuple_pool)+(helper_var_1991.value.tuple.start));
  if(helper_var_2119 < HEAP_SIZE && helper_var_2119 >= 0) {
    helper_var_2055 = *(*(heap)+(helper_var_2119));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_1543;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:688
Generic label_2183;
if(helper_var_1991.value.tuple.start+1 < TUPLE_POOL_SIZE && helper_var_1991.value.tuple.start+1 >= 0) {
  unsigned helper_var_2247 = *((*tuple_pool)+(helper_var_1991.value.tuple.start+1));
  if(helper_var_2247 < HEAP_SIZE && helper_var_2247 >= 0) {
    label_2183 = *(*(heap)+(helper_var_2247));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_1543;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}
Generic helper_var_2311;
if(label_2183.value.tuple.start < TUPLE_POOL_SIZE && label_2183.value.tuple.start >= 0) {
  unsigned helper_var_2375 = *((*tuple_pool)+(label_2183.value.tuple.start));
  if(helper_var_2375 < HEAP_SIZE && helper_var_2375 >= 0) {
    helper_var_2311 = *(*(heap)+(helper_var_2375));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_1543;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}
Generic any_tuple_2_ = helper_var_2311;
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:688
Generic label_2439;
if(label_2183.value.tuple.start+1 < TUPLE_POOL_SIZE && label_2183.value.tuple.start+1 >= 0) {
  unsigned helper_var_2503 = *((*tuple_pool)+(label_2183.value.tuple.start+1));
  if(helper_var_2503 < HEAP_SIZE && helper_var_2503 >= 0) {
    label_2439 = *(*(heap)+(helper_var_2503));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
    goto label_1543;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}
if(label_2439.value.tuple.start != -1 || label_2439.value.tuple.end != -1) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_1543;
}

label_1543:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:569

op_result.exception = 0;
if(any_tuple_2_.type != TUPLE){
  op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
  goto label_2567;
}
Generic helper_var_2631;
if(any_tuple_2_.value.tuple.start + 0 < TUPLE_POOL_SIZE && any_tuple_2_.value.tuple.start + 0>= 0) {
  unsigned helper_var_2695 = *((*tuple_pool)+(any_tuple_2_.value.tuple.start + 0));
  if(helper_var_2695 < HEAP_SIZE && helper_var_2695 >= 0) {
    helper_var_2631 = *(*(heap)+(helper_var_2695));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_2567;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_2567;
}
Generic x_3_ = helper_var_2631;
Generic helper_var_2759;
if(any_tuple_2_.value.tuple.start + 1 < TUPLE_POOL_SIZE && any_tuple_2_.value.tuple.start + 1>= 0) {
  unsigned helper_var_2823 = *((*tuple_pool)+(any_tuple_2_.value.tuple.start + 1));
  if(helper_var_2823 < HEAP_SIZE && helper_var_2823 >= 0) {
    helper_var_2759 = *(*(heap)+(helper_var_2823));
  } else {
    op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
    goto label_2567;
  }
} else {
  op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
  goto label_2567;
}

label_2567:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:170

bpf_printk("x: %d", x_3_.value.integer);
Generic helper_var_2887 = {.type = INTEGER, .value.integer = 0};


  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_2887.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_2887.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
