#ifndef RUNTIME_ELIXIR_GENERIC
#define RUNTIME_ELIXIR_GENERIC

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
  Dynamic generic_result = (Dynamic){0};                 \
  generic_result.type = op_result.result_var.type;       \
  generic_result.value = op_result.result_var.value;

#define ATOM_NIL (Dynamic){.type = ATOM, .value.string = {.start = 0, .end = 2}}
#define ATOM_FALSE (Dynamic){.type = ATOM, .value.string = {.start = 3, .end = 7}}
#define ATOM_TRUE (Dynamic){.type = ATOM, .value.string = {.start = 8, .end = 11}}

#define INT_MAX 2147483647
#define INT_MIN -2147483648

#define QUOTE_HELPER(expr) #expr
#define QUOTE(expr) QUOTE_HELPER(expr)

typedef struct Dynamic Dynamic;
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

typedef union ElixirValue
{
  long integer;
  unsigned u_integer;
  double double_precision;
  Tuple tuple;
  String string;
} ElixirValue;

typedef struct Dynamic
{
  Type type;
  ElixirValue value;
} Dynamic;

typedef struct OpResult
{
  Dynamic result_var;
  int exception;
  char exception_msg[150];
} OpResult;

typedef struct StrFormatSpec
{
  char spec[2];
} StrFormatSpec;

#endif
