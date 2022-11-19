defmodule Honey.Boilerplates do
  import Honey.Utils, only: [gen: 1]

  @moduledoc """
  Module for generating C boilerplate needed to translate Elixir to eBPF readable C.
  Also picks up the translated code and puts it in the appropriate section.
  """

  defstruct [:libbpf_prog_type, :func_args, :license, :elixir_maps, :requires, :translated_code]

  #Keeps parameters on how the translation will be done. Set before calling generate_whole_code.
  def config(libbpf_prog_type, func_args, license, elixir_maps, requires, translated_code) do
    %__MODULE__{
      libbpf_prog_type: libbpf_prog_type,
      func_args: func_args,
      license: license,
      elixir_maps: elixir_maps,
      requires: requires,
      translated_code: translated_code
    }
  end

  # I'd suggest not to use `require` because it is used to import macros
  # I'd suggest using `@include` module attribute, which makes more sense
  # both in naming and order (which is persisted for attributes)
  def requires_to_includes(requires) do
    Enum.reduce(requires, "", fn req, includes ->
      include =
        case req do
          Linux.Bpf ->
            # Already included
            ""

          Bpf.Bpf_helpers ->
            # Already included
            ""

          _ ->
            ""
        end

      include <> includes
    end) <> "\n"
  end

  @doc """
  Adds the needed includes for eBPF.
  """

  def default_includes() do
    gen("""
    #include <linux/bpf.h>
    #include <bpf/bpf_helpers.h>
    """)
  end

  @doc """
  Adds the default includes to the ones specified in config.
  """

  def generate_includes(config) do
    default_includes() <> requires_to_includes(config.requires)
  end

  @doc """
  Adds definitions used by Honey-Potion.
  """

  def generate_defines(_config) do
    gen("""
    #ifndef __inline
    #define __inline \\
      inline __attribute__((always_inline))
    #endif

    #define MAX_ITERATION 100
    #define MAX_STR_SIZE 50
    #define STRING_POOL_SIZE 500
    #define HEAP_SIZE 100
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
    """)
  end

  @doc """
  Generates structs used by Honey-Potion to imitate Elixir datatypes in eBPF.
  """

  def generate_structs(_config) do
    gen("""
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

    """)
  end

  def default_maps do
    gen("""
    // String pool
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

    // Heap
    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(Generic[HEAP_SIZE]));
    } heap_map SEC(\".maps\");

    struct
    {
      __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
      __uint(max_entries, 1);
      __uint(key_size, sizeof(int));
      __uint(value_size, sizeof(int));
    } heap_index_map SEC(\".maps\");
    """)
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
                  Macro.to_string(value)

                _ ->
                  Integer.to_string(value)
              end

            "__uint(#{key}, #{value});"
          end)
          |> Enum.join("\n")

        """
        struct {
          #{fields}
          __type(key, int);
          __uint(value_size, sizeof(Generic));
        } #{map_name} SEC(".maps")
        """
      end)

    Enum.join(c_maps, "\n") <> "\n"
  end

  def generate_maps(config) do
    default_maps() <> create_c_maps(config.elixir_maps)
  end

  @doc """
  Creates the method to access a member of the Generic struct in C.
  """

  def generate_getMember(config) do
    gen("""
    static void getMember(OpResult *result, Generic *elixir_struct, char member_name[20], Generic *member)
    {
      *result = (OpResult){.exception = 0};
      int zero = 0;
      Generic(*heap)[HEAP_SIZE] = bpf_map_lookup_elem(&heap_map, &zero);
      if (!heap)
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, getMember function)."};
        return;
      }
    #{gen(case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" -> "if (elixir_struct->type == TYPE_Syscalls_enter_kill_arg)
            {
              if (__builtin_memcmp(member_name, \"pad\", 4) == 0)
              {
                unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_pad;
                if (index < HEAP_SIZE)
                {
                  *member = (*heap)[index];
                }
              }
              else if (__builtin_memcmp(member_name, \"syscall_nr\", 11) == 0)
              {
                unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_syscall_nr;
                if (index < HEAP_SIZE)
                {
                  *member = (*heap)[index];
                }
              }
              else if (__builtin_memcmp(member_name, \"pid\", 4) == 0)
              {
                unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_pid;
                if (index < HEAP_SIZE)
                {
                  *member = (*heap)[index];
                }
              }
              else if (__builtin_memcmp(member_name, \"sig\", 4) == 0)
              {
                unsigned index = elixir_struct->value.syscalls_enter_kill_args.pos_sig;
                if (index < HEAP_SIZE)
                {
                  *member = (*heap)[index];
                }
              }
            }"
      _ -> ""
    end)}
      *result = (OpResult){.exception = 1, .exception_msg = "(InvalidMember) Tried to access invalid member of a struct."};
      return;
    }
    """)
  end

  @doc """
  Adds the functions that replicate the behavior of Elixirs methods.
  Located in c_boilerplates/runtime_functions.c.
  """

  def generate_runtime_functions(config) do
    path = Path.join(:code.priv_dir(:honey), "c_boilerplates/runtime_functions.c")
    # :code.generate_path()
    File.read!(path) <> generate_getMember(config) <> "\n\n"
  end

  @doc """
  Prepares the main method to operate normally.
  """

  def beginning_main_code do
    gen("""
    StrFormatSpec str_param1;
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

    Generic(*heap)[HEAP_SIZE] = bpf_map_lookup_elem(&heap_map, &zero);
    if (!heap)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\"};
      goto CATCH;
    }

    unsigned *heap_index = bpf_map_lookup_elem(&heap_index_map, &zero);
    if (!heap_index)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\"};
      goto CATCH;
    }
    """)
  end

  @doc """
  Takes the libbpf program type from the @sec before the main method and transforms it into boilerplate.
  Currently only supports tracepoint/syscalls/sys_enter_kill
  """

  def generate_middle_main_code(config) do
    case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        [arg | _] = config.func_args

        # FIXME: comment in a first clause
        gen("""
        Generic #{arg} = {.type = TYPE_Syscalls_enter_kill_arg, .value.syscalls_enter_kill_args = {(*heap_index)++, (*heap_index)++, (*heap_index)++, (*heap_index)++}};
        unsigned last_index = #{arg}.value.syscalls_enter_kill_args.pos_sig;
        if (#{arg}.value.syscalls_enter_kill_args.pos_pad < HEAP_SIZE)
        {
          // (*heap)[#{arg}.value.syscalls_enter_kill_args.pos_pad] = (Generic){.type = INTEGER, .value.integer = ctx_arg->pad};
        }
        if (#{arg}.value.syscalls_enter_kill_args.pos_syscall_nr < HEAP_SIZE)
        {
          (*heap)[#{arg}.value.syscalls_enter_kill_args.pos_syscall_nr] = (Generic){.type = INTEGER, .value.integer = ctx_arg->syscall_nr};
        }
        if (#{arg}.value.syscalls_enter_kill_args.pos_pid < HEAP_SIZE)
        {
          (*heap)[#{arg}.value.syscalls_enter_kill_args.pos_pid] = (Generic){.type = INTEGER, .value.integer = ctx_arg->pid};
        }
        if (#{arg}.value.syscalls_enter_kill_args.pos_sig < HEAP_SIZE)
        {
          (*heap)[#{arg}.value.syscalls_enter_kill_args.pos_sig] = (Generic){.type = INTEGER, .value.integer = ctx_arg->sig};
        }
        """)
    end
  end

  @doc """
  Generates the return of the code. Returns if the value is an integer or goes to the CATCH error otherwise.
  """

  def generate_ending_main_code(return_var_name) do
    gen("""
    if (#{return_var_name}.type != INTEGER) {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(IncorrectReturn) eBPF function is not returning an integer.\"};
      goto CATCH;
    }
    return #{return_var_name}.value.integer;

    CATCH:
      bpf_printk(\"** %s\\n\", op_result.exception_msg);
      return 0;
    """)
  end

  @doc """
  Adds the license of the eBPF program.
  """

  def generate_license(config) do
    gen("""
    char LICENSE[] SEC("license") = "#{config.license}";


    """)
  end

  @doc """
  Adds the arguments of the main function.
  Currently only ctx for tracepoint/syscalls/sys_enter_kill
  """

  def generate_main_arguments(config) do
    case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        "struct syscalls_enter_kill_args *ctx_arg"

      _ ->
        ""
    end
  end

  @doc """
  Puts together all main generating methods and the translated code.
  """

  def generate_main(config) do
    gen("""
    SEC("#{config.libbpf_prog_type}")
    int main_func(#{generate_main_arguments(config)}) {
      #{beginning_main_code()}
      #{generate_middle_main_code(config)}
      // =============== beginning of user code ===============
      #{config.translated_code.code}
      // =============== end of user code ==============
      #{generate_ending_main_code(config.translated_code.return_var_name)}
    }
    """)
  end

  @doc """
  Calls the methods necessary to create the boilerplates and add the translated version.
  """

  def generate_whole_code(config) do
    gen(
      generate_includes(config) <>
        generate_defines(config) <>
        generate_structs(config) <>
        generate_maps(config) <>
        generate_license(config) <>
        generate_runtime_functions(config) <>
        generate_main(config)
    )
  end
end
