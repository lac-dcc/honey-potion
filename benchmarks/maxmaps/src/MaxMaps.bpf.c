// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:31
// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:246
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdlib.h>
#include <runtime_structures.bpf.h>
#include <runtime_functions.bpf.c>

struct {
  
__uint(type, BPF_MAP_TYPE_ARRAY);
__uint(max_entries, 13);

  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(Generic));
} Example_map SEC(".maps");

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:497
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
// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:524
char LICENSE[] SEC("license") = "Dual BSD/GPL";


// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:557
SEC("tracepoint/syscalls/sys_enter_write")
int main_func(syscalls_enter_write_args *ctx_arg) {
  // Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:383
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
  

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:569
// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:239
int i = 0;
Generic *pre_entry = bpf_map_lookup_elem(&Example_map, &i);

Generic entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

Generic tosum = {.type = INTEGER, .value.integer = i + 1};
BINARY_OPERATION(result, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result, BPF_ANY);

  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result1, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result1, BPF_ANY);


  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result2, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result2, BPF_ANY);


  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result3, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result3, BPF_ANY);


  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result4, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result4, BPF_ANY);
  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result5, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result5, BPF_ANY);
  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result6, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result6, BPF_ANY);
  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result7, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result7, BPF_ANY);
  i++;
pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result8, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result8, BPF_ANY);
  i++;


pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result9, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result9, BPF_ANY);
  i++;


pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result10, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result10, BPF_ANY);

  i++;

pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result11, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result11, BPF_ANY);

  i++;

pre_entry = bpf_map_lookup_elem(&Example_map, &i);

entry = (Generic){0};
if(!pre_entry) {
  // helper_var_3842 = ATOM_NIL;
  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map 'Example_map'."};
  goto CATCH;
}
entry = *pre_entry;
entry.type = entry.type == INVALID_TYPE ? INTEGER : entry.type;

op_result.exception = 0;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/translator.ex:138

tosum.value.integer = i + 1;
BINARY_OPERATION(result12, Sum, entry, tosum)
bpf_map_update_elem(&Example_map, &i, &result12, BPF_ANY);

  i++;
Generic helper_var_8194 = {.type = INTEGER, .value.integer = 0};

  // =============== end of user code ==============
  // Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:447
if (helper_var_8194.type != INTEGER) {
  op_result = (OpResult){.exception = 1, .exception_msg = "(IncorrectReturn) eBPF function is not returning an integer."};
  goto CATCH;
}
return helper_var_8194.value.integer;

CATCH:
  bpf_printk("** %s\n", op_result.exception_msg);
  return 0;

}
