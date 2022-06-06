defmodule Honey.Boilerplates do
  defstruct [:libbpf_prog_type, :func_args, :license, :elixir_maps, :requires, :translated_code]

  def config(libbpf_prog_type, func_args, license, elixir_maps, requires, translated_code) do
    %Honey.Boilerplates{libbpf_prog_type: libbpf_prog_type, func_args: func_args, license: license, elixir_maps: elixir_maps, requires: requires, translated_code: translated_code}
  end

  def requires_to_includes(requires) do
    Enum.reduce(requires, "", fn req, includes ->
      include =
        case req do
          Linux.Bpf ->
            "" # Already included

          Bpf.Bpf_helpers ->
            "" # Already included

          _ ->
            ""
        end

      include <> includes
    end) <> "\n"
  end

  def get_default_includes() do
    "#include <linux/bpf.h>

    #include <bpf/bpf_helpers.h>

    "
  end

  def get_includes(config) do
    get_default_includes()
    <> requires_to_includes(config.requires)
  end

  def get_defines(_config) do
    "#ifndef __inline
    #define __inline \\
      inline __attribute__((always_inline))
    #endif

    #define MAX_ITERATION 100
    #define MAX_STR_SIZE 50
    #define STRING_POOL_SIZE 500
    #define ARRAY_POOL_SIZE 100
    #define MAX_STRUCT_MEMBERS 5

    #define field_pad 1
    #define field_syscall_nr 2
    #define field_pid 3
    #define field_sig 4

    #define BINARY_OPERATION(generic_result, op, var1, var2) \\
      op(&op_result, &var1, &var2);                          \\
      if (op_result.exception)                               \\
        goto CATCH;                                          \\
      Generic generic_result;                                \\
      generic_result.type = op_result.result_var.type;       \\
      generic_result.value = op_result.result_var.value;

    #define ATOM_NIL (Generic){.type = ATOM, .value.string = {.start = 0, .end = 2}}
    #define ATOM_FALSE (Generic){.type = ATOM, .value.string = {.start = 3, .end = 7}}
    #define ATOM_TRUE (Generic){.type = ATOM, .value.string = {.start = 8, .end = 11}}

    #define INT_MAX 2147483647
    #define INT_MIN -2147483648

    #define QUOTE_HELPER(expr) #expr
    #define QUOTE(expr) QUOTE_HELPER(expr)

    "
  end

  def get_structs(_config) do
    "typedef struct Generic Generic;
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
      int idx;
      int value_idx;
      int nextElement_idx;
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
      int integer;
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

    struct syscalls_enter_kill_args
    {
      /**
       * This is the tracepoint arguments of the kill functions.
       * Defined at: /sys/kernel/debug/tracing/events/syscalls/sys_enter_kill/format
       */
      long long pad;

      long syscall_nr;
      long pid;
      long sig;
    };

    "
  end

  def get_default_maps() do
    "// String pool
    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(char[STRING_POOL_SIZE]));
    } string_pool_map SEC(\".maps\");

    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(int));
    } string_pool_index_map SEC(\".maps\");

    // Array pool
    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(Generic[ARRAY_POOL_SIZE]));
    } array_pool_map SEC(\".maps\");

    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(int));
    } array_pool_index_map SEC(\".maps\");

    "
  end

  def create_c_maps(maps) do
    c_maps =
      Enum.map(maps, fn elixir_map ->
        map_name = elixir_map[:name]
        map_content = elixir_map[:content]
        fields =
          Enum.map(map_content, fn {key, value} ->
            value =
              case key do
                :type ->
                  Atom.to_string(value)
                  |> String.replace("Elixir.", "")

                _ ->
                  Integer.to_string(value)
              end

            "__uint(#{Atom.to_string(key)}, #{value});"
          end)
          |> Enum.join("\n")

        "struct {\n" <>
          fields <>
          "__type(key, int);" <>
          "__uint(value_size, sizeof(Generic));" <>
          "\n" <>
          "} #{map_name} SEC(\".maps\");\n"
      end)

    Enum.join(c_maps, "\n") <> "\n"
  end

  def get_maps(config) do
    get_default_maps()
    <> create_c_maps(config.elixir_maps)
  end

  def generate_getMember(config) do
    "static void getMember(OpResult *result, Generic *elixir_struct, char member_name[20], Generic *member)
    {
      *result = (OpResult){.exception = 0};
      int zero = 0;
      Generic(*array_pool)[ARRAY_POOL_SIZE] = bpf_map_lookup_elem(&array_pool_map, &zero);
      if (!array_pool)
      {
        *result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, getMember function).\"};
        return;
      }"

    <> case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        "if (elixir_struct->type == TYPE_Syscalls_enter_kill_arg)
        {
          if (__builtin_memcmp(member_name, \"pad\", 4) == 0)
          {
            unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_pad;
            if (index < ARRAY_POOL_SIZE)
            {
              *member = (*array_pool)[index];
            }
          }
          else if (__builtin_memcmp(member_name, \"syscall_nr\", 11) == 0)
          {
            unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_syscall_nr;
            if (index < ARRAY_POOL_SIZE)
            {
              *member = (*array_pool)[index];
            }
          }
          else if (__builtin_memcmp(member_name, \"pid\", 4) == 0)
          {
            unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_pid;
            if (index < ARRAY_POOL_SIZE)
            {
              *member = (*array_pool)[index];
            }
          }
          else if (__builtin_memcmp(member_name, \"sig\", 4) == 0)
          {
            unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_sig;
            if (index < ARRAY_POOL_SIZE)
            {
              *member = (*array_pool)[index];
            }
          }
        }"

      _ ->
        ""
    end

    <> "*result = (OpResult){.exception = 1, .exception_msg = \"(InvalidMember) Tried to access invalid member of a struct.\"};
    return;
    }"
  end

  def get_runtime_functions(config) do
    path = Path.join(:code.priv_dir(:honey), "c_boilerplates/runtime_functions.c")
    # :code.get_path()
    File.read!(path)
    <> generate_getMember(config)
    <> "\n\n"
  end

  def get_beggning_main_code() do
    "StrFormatSpec str_param1;
    StrFormatSpec str_param2;
    StrFormatSpec str_param3;

    OpResult op_result;

    int zero = 0;
    char(*string_pool)[STRING_POOL_SIZE] = bpf_map_lookup_elem(&string_pool_map, &zero);
    if (!string_pool)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\"};
      goto CATCH;
    }

    unsigned *string_pool_index = bpf_map_lookup_elem(&string_pool_index_map, &zero);
    if (!string_pool_index)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\"};
      goto CATCH;
    }

    __builtin_memcpy(*string_pool, \"nil\", 3);
    __builtin_memcpy(*string_pool + 3, \"false\", 5);
    __builtin_memcpy(*string_pool + 3 + 5, \"true\", 4);

    Generic(*array_pool)[ARRAY_POOL_SIZE] = bpf_map_lookup_elem(&array_pool_map, &zero);
    if (!array_pool)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access array pool, main function).\"};
      goto CATCH;
    }

    unsigned *array_pool_index = bpf_map_lookup_elem(&array_pool_index_map, &zero);
    if (!array_pool_index)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access array pool index, main function).\"};
      goto CATCH;
    }

    "
  end

  def get_middle_main_code(config) do
    case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        "Generic #{Enum.at(config.func_args, 0)} = {.type = TYPE_Syscalls_enter_kill_arg, .value.syscalls_enter_kill_args = {(*array_pool_index)++, (*array_pool_index)++, (*array_pool_index)++, (*array_pool_index)++}};
        unsigned last_index = #{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_sig;
        if (#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_pad < ARRAY_POOL_SIZE)
        {
          // (*array_pool)[#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_pad] = (Generic){.type = INTEGER, .value.integer = ctx_arg->pad};
        }
        if (#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_syscall_nr < ARRAY_POOL_SIZE)
        {
          (*array_pool)[#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_syscall_nr] = (Generic){.type = INTEGER, .value.integer = ctx_arg->syscall_nr};
        }
        if (#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_pid < ARRAY_POOL_SIZE)
        {
          (*array_pool)[#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_pid] = (Generic){.type = INTEGER, .value.integer = ctx_arg->pid};
        }
        if (#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_sig < ARRAY_POOL_SIZE)
        {
          (*array_pool)[#{Enum.at(config.func_args, 0)}.value.syscalls_enter_kill_args.pos_sig] = (Generic){.type = INTEGER, .value.integer = ctx_arg->sig};
        }"
    end
  end

  def get_ending_main_code(return_var_name) do
    "if (#{return_var_name}.type != INTEGER)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(IncorrectReturn) eBPF function is not returning an integer.\"};
      goto CATCH;
    }
    return #{return_var_name}.value.integer;

  CATCH:
    bpf_printk(\"** %s\\n\", op_result.exception_msg);
    return 0;
    "
  end

  def get_license(config) do
    "char LICENSE[] SEC(\"license\") = \"#{config.license}\";\n\n"
  end

  def get_main_arguments(config) do
    case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        "struct syscalls_enter_kill_args *ctx_arg"

      _ ->
      ""
    end
  end

  def get_main(config) do
    "SEC(\"#{config.libbpf_prog_type}\")\n" <>
    "int main_func(#{get_main_arguments(config)}) {" <>
    get_beggning_main_code() <>
    get_middle_main_code(config) <>
    "\n// =============== beggining of user code ===============\n" <>
    config.translated_code.code <>
    "\n// =============== end of user code ===============\n" <>
    get_ending_main_code(config.translated_code.return_var_name) <>
    "}"
  end

  def get_whole_code(config) do
    get_includes(config) <>
    get_defines(config) <>
    get_structs(config) <>
    get_maps(config) <>
    get_license(config) <>
    get_runtime_functions(config) <>
    get_main(config)
  end

end
