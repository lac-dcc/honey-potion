#ifndef RUNTIME_BPF_STRUCTS_HONEY
#define RUNTIME_BPF_STRUCTS_HONEY
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

#ifndef __inline
#define __inline \
  inline __attribute__((always_inline))
#endif

#define MAX_ITERATION 100
#define MAX_STR_SIZE 50
#define STRING_POOL_SIZE 500
#define TUPLE_POOL_SIZE 500
#define HEAP_SIZE 100
#define MAX_STRUCT_MEMBERS 5

#define field_pad 1
#define field_syscall_nr 2
#define field_pid 3
#define field_sig 4

#define BINARY_OPERATION(generic_result, op, var1, var2) \
  op(&op_result, &var1, &var2);                          \
  if (op_result.exception)                               \
    goto CATCH;                                          \
  Generic generic_result;                                \
  generic_result.type = op_result.result_var.type;       \
  generic_result.value = op_result.result_var.value;

#define ATOM_NIL (Generic){.type = ATOM, .value.string = {.start = 0, .end = 2}}
#define ATOM_FALSE (Generic){.type = ATOM, .value.string = {.start = 3, .end = 7}}
#define ATOM_TRUE (Generic){.type = ATOM, .value.string = {.start = 8, .end = 11}}

#define INT_MAX 2147483647
#define INT_MIN -2147483648

#define QUOTE_HELPER(expr) #expr
#define QUOTE(expr) QUOTE_HELPER(expr)

typedef struct Generic Generic;
typedef enum Operation Operation;
typedef enum Type Type;
typedef struct Tuple Tuple;
typedef union ElixirValue ElixirValue;

typedef enum Type
{
  INVALID_TYPE,
  PATTERN_M,
  INTEGER,
  DOUBLE,
  STRING,
  ATOM,
  TUPLE,
  LIST,
  STRUCT,
  TYPE_Syscalls_enter_kill_arg
} Type;

typedef struct Tuple
{
  int start;
  int end;
} Tuple;

typedef struct String
{
  int start;
  int end;
} String;

typedef struct StrToPrint
{
  char str[MAX_STR_SIZE + 6];
} StrToPrint;

typedef struct struct_Syscalls_enter_kill_args
{
  unsigned pos_pad;
  unsigned pos_syscall_nr;
  unsigned pos_pid;
  unsigned pos_sig;
} struct_Syscalls_enter_kill_args;

typedef union ElixirValue
{
  long integer;
  unsigned u_integer;
  double double_precision;
  Tuple tuple;
  String string;
  struct_Syscalls_enter_kill_args syscalls_enter_kill_args;
} ElixirValue;

typedef struct Generic
{
  Type type;
  ElixirValue value;
} Generic;

typedef struct OpResult
{
  Generic result_var;
  int exception;
  char exception_msg[150];
} OpResult;

typedef struct StrFormatSpec
{
  char spec[2];
} StrFormatSpec;

// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:204
// String pool
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(char[STRING_POOL_SIZE]));
} string_pool_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(int));
} string_pool_index_map SEC(".maps");

// Tuple
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(unsigned[TUPLE_POOL_SIZE]));
} tuple_pool_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(unsigned));
} tuple_pool_index_map SEC(".maps");

// Heap
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(Generic[HEAP_SIZE]));
} heap_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(int));
} heap_index_map SEC(".maps");


#endif


