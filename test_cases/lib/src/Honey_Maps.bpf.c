// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:165
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>

struct {
  __uint(max_entries, 3);


__uint(type, BPF_MAP_TYPE_ARRAY);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(Generic));
} Example_map SEC(".maps");

// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:420
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
// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:448
char LICENSE[] SEC("license") = "Dual BSD/GPL";


// Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:481
SEC("tracepoint/syscalls/sys_enter_write")
int main_func(syscalls_enter_write_args *ctx_arg) {
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
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:237
Generic helper_var_1922 = {.type = INTEGER, .value.integer = 0};
if(helper_var_1922.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
  goto CATCH;
}
Generic *helper_var_1986 = bpf_map_lookup_elem(&Example_map, &(helper_var_1922.value.integer));

Generic helper_var_2050 = (Generic){.type = INTEGER, .value.integer = 0};

Generic helper_var_1794 = helper_var_1986 ? ATOM_TRUE : ATOM_FALSE;
Generic helper_var_1858 = (Generic){0};
if(!helper_var_1986) {
  // helper_var_1858 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
} else {
  helper_var_1858 = *helper_var_1986;
  helper_var_1858.type = helper_var_1858.type == INVALID_TYPE ? INTEGER : helper_var_1858.type;
}
/* // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1037
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_1794;
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
  (*heap)[(*heap_index)+1] = helper_var_1858;
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

Generic helper_var_2114 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
 */

op_result.exception = 0;
Generic entry_0_1_ = helper_var_1858;

label_1730:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:237
Generic helper_var_2370 = {.type = INTEGER, .value.integer = 1};
if(helper_var_2370.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
  goto CATCH;
}
Generic *helper_var_2434 = bpf_map_lookup_elem(&Example_map, &(helper_var_2370.value.integer));

Generic helper_var_2498 = (Generic){.type = INTEGER, .value.integer = 0};

Generic helper_var_2242 = helper_var_2434 ? ATOM_TRUE : ATOM_FALSE;
Generic helper_var_2306 = (Generic){0};
if(!helper_var_2434) {
  // helper_var_2306 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
} else {
  helper_var_2306 = *helper_var_2434;
  helper_var_2306.type = helper_var_2306.type == INVALID_TYPE ? INTEGER : helper_var_2306.type;
}
/* // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1037
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_2242;
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
  (*heap)[(*heap_index)+1] = helper_var_2306;
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

Generic helper_var_2562 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
 */

op_result.exception = 0;
Generic entry_1_2_ = helper_var_2306;

label_2178:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:561
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:237
Generic helper_var_2818 = {.type = INTEGER, .value.integer = 2};
if(helper_var_2818.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
  goto CATCH;
}
Generic *helper_var_2882 = bpf_map_lookup_elem(&Example_map, &(helper_var_2818.value.integer));

Generic helper_var_2946 = (Generic){.type = INTEGER, .value.integer = 0};

Generic helper_var_2690 = helper_var_2882 ? ATOM_TRUE : ATOM_FALSE;
Generic helper_var_2754 = (Generic){0};
if(!helper_var_2882) {
  // helper_var_2754 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
} else {
  helper_var_2754 = *helper_var_2882;
  helper_var_2754.type = helper_var_2754.type == INVALID_TYPE ? INTEGER : helper_var_2754.type;
}
/* // Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:1037
if(*heap_index < (HEAP_SIZE-0)) {
  (*heap)[(*heap_index)+0] = helper_var_2690;
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
  (*heap)[(*heap_index)+1] = helper_var_2754;
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

Generic helper_var_3010 = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
 */

op_result.exception = 0;
Generic entry_2_3_ = helper_var_2754;

label_2626:
if(op_result.exception == 1) {
  goto CATCH;
}

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:339
Generic helper_var_3074 = {.type = INTEGER, .value.integer = 0};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_3138 = {.type = INTEGER, .value.integer = 1};
BINARY_OPERATION(helper_var_3202, Sum, entry_0_1_, helper_var_3138)

if(helper_var_3074.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
  goto CATCH;
}
int helper_var_3266 = bpf_map_update_elem(&Example_map, &(helper_var_3074.value.integer), &helper_var_3202, BPF_ANY);
Generic helper_var_3330 = (Generic){.type = INTEGER, .value.integer = helper_var_3266};

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:339
Generic helper_var_3394 = {.type = INTEGER, .value.integer = 1};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_3458 = {.type = INTEGER, .value.integer = 2};
BINARY_OPERATION(helper_var_3522, Sum, entry_1_2_, helper_var_3458)

if(helper_var_3394.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
  goto CATCH;
}
int helper_var_3586 = bpf_map_update_elem(&Example_map, &(helper_var_3394.value.integer), &helper_var_3522, BPF_ANY);
Generic helper_var_3650 = (Generic){.type = INTEGER, .value.integer = helper_var_3586};

// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:339
Generic helper_var_3714 = {.type = INTEGER, .value.integer = 2};
// Generated at /home/vinicius/honey-potion/lib/honey/translator.ex:136

Generic helper_var_3778 = {.type = INTEGER, .value.integer = 3};
BINARY_OPERATION(helper_var_3842, Sum, entry_2_3_, helper_var_3778)

if(helper_var_3714.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
  goto CATCH;
}
int helper_var_3906 = bpf_map_update_elem(&Example_map, &(helper_var_3714.value.integer), &helper_var_3842, BPF_ANY);
Generic helper_var_3970 = (Generic){.type = INTEGER, .value.integer = helper_var_3906};

Generic helper_var_4034 = {.type = INTEGER, .value.integer = 0};

  // =============== end of user code ==============
  // Generated at /home/vinicius/honey-potion/lib/honey/boilerplates.ex:367
if (helper_var_4034.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_4034.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
