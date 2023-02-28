defmodule Honey.Boilerplates.AddOn do
  defstruct [:includes, :defines, :code_before_structs, :structs, :main_code]
end

defmodule Honey.Boilerplates.Config do
  defstruct [:prog_type, :func_args, :license, :elixir_maps, :requires, :translated_code]

  def new(prog_type, func_args, license, elixir_maps, requires, translated_code) do
    %__MODULE__{
      prog_type: prog_type,
      func_args: func_args,
      license: license,
      elixir_maps: elixir_maps,
      requires: requires,
      translated_code: translated_code
    }
  end
end

defmodule Honey.Boilerplates do
  alias Honey.{Struct}
  import Honey.Utils, only: [gen: 1]

  # I'd suggest not to use `require` because it is used to import macros
  # I'd suggest using `@include` module attribute, which makes more sence
  # both in naming and order (which is persisted for attributes)
  def requires_to_includes(requires) do
    Enum.reduce(requires, "", fn req, includes ->
      include =
        case req do
          Linux.Bpf ->
            # Already included
            ""

          Bpf.BpfHelpers ->
            # Already included
            ""

          _ ->
            ""
        end

      include <> includes
    end) <> "\n"
  end

  def default_includes() do
    gen("""
    #include <linux/bpf.h>
    #include <bpf/bpf_helpers.h>
    #include <linux/if_ether.h>
    #include <linux/ip.h>
    #include <linux/icmp.h>
    """)
  end

  def generate_includes(config) do
    default_includes() <> requires_to_includes(config.requires)
  end

  def generate_runtime_defines() do
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

  def generate_progtype_defines(config) do
    Enum.reduce(config.prog_type.add_on.structs, {"", 1}, fn struct, {all_defines, counter} ->
      {struct_defines, counter} =
        Enum.reduce(struct.fields, {"", counter}, fn field, {struct_defines, counter} ->
          {struct_defines <> "#define #{Struct.field_to_id!(struct, field)} #{counter}\n",
           counter + 1}
        end)

      {all_defines <> struct_defines, counter}
    end)
    |> elem(0)
    |> gen()
  end

  def generate_defines(config) do
    generate_runtime_defines() <>
      generate_progtype_defines(config)
  end

  def generate_custom_types(config) do
    Enum.map(config.prog_type.add_on.structs, &Struct.to_type_enum/1)
    |> Enum.join(",\n")
  end

  def generate_custom_ElixirValue_fields(config) do
    Enum.reduce(config.prog_type.add_on.structs, "", fn struct, code ->
      code <> "#{Struct.to_c_type(struct)} #{Struct.to_ElixirValue_accessor(struct)};\n"
    end)
  end

  def generate_runtime_structs(config) do
    gen("""
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
      #{generate_custom_types(config)}
    } Type;

    typedef struct Generic Generic;
    typedef enum Operation Operation;
    typedef enum Type Type;
    typedef struct Tuple Tuple;
    typedef union ElixirValue ElixirValue;

    typedef struct Tuple
    {
      unsigned idx;
      unsigned value_idx;
      unsigned nextElement_idx;
    } Tuple;

    typedef struct String
    {
      unsigned start;
      unsigned end;
    } String;

    typedef struct StrToPrint
    {
      char str[MAX_STR_SIZE + 6];
    } StrToPrint;

    typedef union ElixirValue
    {
      int integer;
      unsigned u_integer;
      double double_precision;
      Tuple tuple;
      String string;
      #{generate_custom_ElixirValue_fields(config)}
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
    """)
  end

  def generate_progtype_structs(config) do
    Enum.reduce(config.prog_type.add_on.structs, "", fn struct, code ->
      code <>
        """
        typedef struct #{Struct.to_c_type(struct)}
        {
          #{Enum.reduce(struct.fields, "", fn field, code -> code <> "unsigned #{Struct.field_to_c_field!(struct, field)};\n" end)}
        } #{Struct.to_c_type(struct)};
        """
    end)
    |> gen()
  end

  def generate_structs(config) do
    generate_progtype_structs(config) <>
      generate_runtime_structs(config)
  end

  def generate_addon_before_structs(config) do
    config.prog_type.add_on.code_before_structs || ""
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
            {bpf_key, bpf_value} =
              case key do
                :type ->
                  {"type", Macro.to_string(value)}

                :key_type ->
                  case value do
                    %{type: :string, size: size} ->
                      {"key_size", "sizeof(char[#{size}])"}
                  end
                _ ->
                  {key, value}
              end

            "__uint(#{bpf_key}, #{bpf_value});"
          end)
          |> Enum.join("\n")

        """
        struct {
          #{fields}
          #{if(map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY or map_content.type == BPF_MAP_TYPE_ARRAY) do
            "__type(key, int);"
          end}
          __uint(value_size, sizeof(Generic));
        } #{map_name} SEC(".maps");
        """
      end)

    Enum.join(c_maps, "\n") <> "\n"
  end

  def generate_maps(config) do
    default_maps() <> create_c_maps(config.elixir_maps)
  end

  def generate_getMember(config) do
    gen("""
    static __inline void getMember(OpResult *result, Generic *elixir_struct, unsigned member_id, Generic *member)
    {
      *result = (OpResult){.exception = 0};
      int zero = 0;
      Generic(*heap)[HEAP_SIZE] = bpf_map_lookup_elem(&heap_map, &zero);
      if (!heap)
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, getMember function)."};
        return;
      }
    #{Enum.reduce(config.prog_type.add_on.structs, "", fn struct, code -> code <> """
        if (elixir_struct->type == #{Struct.to_type_enum(struct)}) {
          #{Enum.reduce(struct.fields, "", fn field, code -> code <> """
        if(member_id == #{Struct.field_to_id!(struct, field)}) {
          unsigned index = elixir_struct->value.#{Struct.to_ElixirValue_accessor(struct)}.#{Struct.field_to_c_field!(struct, field)};
          if (index < HEAP_SIZE)
          {
            *member = (*heap)[index];
            return;
          }
        }
        """ end)}
        }
      """ end)
    |> gen()}
      *result = (OpResult){.exception = 1, .exception_msg = "(InvalidMember) Tried to access invalid member of a struct."};
      return;
    }
    """)
  end

  def generate_runtime_functions(config) do
    path = Path.join(:code.priv_dir(:honey), "c_boilerplates/runtime_functions.c")
    # :code.generate_path()
    File.read!(path) <> generate_getMember(config) <> "\n\n"
  end

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
    *string_pool_index = 0;

    __builtin_memcpy(*string_pool, \"nil\", 3);
    __builtin_memcpy(*string_pool + 3, \"false\", 5);
    __builtin_memcpy(*string_pool + 3 + 5, \"true\", 4);
    *string_pool_index = 12;

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
    *heap_index = 0;
    """)
  end

  def generate_progtype_main(config) do
    config.prog_type.add_on.main_code <>
      (config.func_args
       |> Enum.with_index(fn func_arg, index ->
         "Generic #{func_arg} = converted_arg_#{index + 1};"
       end)
       |> Enum.join("\n"))
  end

  def generate_middle_main_code(config) do
    generate_progtype_main(config)
  end

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

  def generate_license(config) do
    gen("""
    char LICENSE[] SEC("license") = "#{config.license}";
    """)
  end

  def generate_main_arguments(config) do
    config.prog_type.main_arguments_types
    |> Enum.with_index(fn arg_type, index -> "#{arg_type} arg_#{index + 1}" end)
    |> Enum.join(",")
  end

  def generate_main(config) do
    gen("""
    SEC("#{config.prog_type.sec}")
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

  def generate_whole_code(config) do
    gen(
      generate_includes(config) <>
        generate_defines(config) <>
        generate_addon_before_structs(config) <>
        generate_structs(config) <>
        generate_maps(config) <>
        generate_license(config) <>
        generate_runtime_functions(config) <>
        generate_main(config)
    )
  end
end
