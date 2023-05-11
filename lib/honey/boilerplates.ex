defmodule Honey.Boilerplates do
  import Honey.Utils, only: [gen: 1]
  alias Honey.Utils
  alias Honey.Info

  @moduledoc """
  Module for generating C boilerplate needed to translate Elixir to eBPF readable C.
  Also picks up the translated code and puts it in the appropriate section.
  """
alias Honey.Boilerplates

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

  @doc """
  Calls the methods necessary to create the boilerplates and add the translated code.
  """

  def generate_whole_code(config) do
    gen(
      generate_includes(config) <>
      generate_maps(config) <>
      generate_ctx_struct(config) <>
      generate_license(config) <>
      generate_main(config)
    )
  end

  @doc """
  Generates the generic front-end for the bpf program.
  """

  def generate_frontend_code(env) do
    module_name = Utils.module_name(env)

    include = """
    #include <bpf/bpf.h>
    #include <bpf/libbpf.h>
    #include <stdio.h>
    #include <unistd.h>
    #include <runtime_generic.bpf.h>
    #include "#{module_name}.skel.h"\n
    """

    {output_decl, output_func} = generate_output_function(env)

    main = """
    \nint main(int argc, char **argv) {
      struct #{module_name}_bpf *skel;
      int err;

      skel = #{module_name}_bpf__open();
      if(!skel){
        fprintf(stderr, "Skeleton failed opening.\\n");
        return 1;
      }

      err = #{module_name}_bpf__load(skel);
      if(err){
        fprintf(stderr, "Failed loading or verification of BPF skeleton.\\n");
        #{module_name}_bpf__destroy(skel);
        return -err;
      }

      err = #{module_name}_bpf__attach(skel);
      if(err){
        fprintf(stderr, "Failed attaching BPF skeleton.\\n");
        #{module_name}_bpf__destroy(skel);
        return -err;
      }

      output(skel);
    }
    """

    include <> output_decl <> main <> output_func
  end

  def generate_output_function(env) do
    {_,_,_,maps} = Info.get_backend_info(env)

    # Enumerate through functions and return the print of the elements that were requested.
    output = Enum.map(maps, fn map ->
      {name, _type, _max_entries, print, print_elem} = Info.get_maps_attributes(map)
      if(!(print == true)) do
        ""
      else
        if(print_elem == nil) do
          raise "RuntimeError: When :print is true, make sure to specify :print_elem."
        end
        name = Atom.to_string(name)
        """
          /* Printing map of name #{name} */
          struct bpf_map* #{name} = skel->maps.#{name};
          int #{name}_fd = bpf_map__fd(#{name});
          while(1){
            printf("\\e[1;1H\\e[2J");
            printf("#{name}:\\n");
            #{Enum.map(print_elem, fn elem ->
              case elem do
                {elem_name, key} when is_binary(elem_name) and is_integer(key)->
                  """
                  key = #{Integer.to_string(key)};
                  success = bpf_map_lookup_elem(#{name}_fd, &key, &value);
                  if(success == 0){
                    printf("%s %ld\\n", "#{elem_name}", value.value.integer);
                  }
                  else
                  {
                    printf("Element %s failed to print with key %d.\\n", "#{elem_name}", #{Integer.to_string(key)});
                  }
                  """
                _ -> raise "RuntimeError: Please specify :print_elem key with a list of tuples {name (string), key (integer)} when :print is true."
                end
              end
            ) |> Enum.join}
        """
      end
    end) |> Enum.join

    #If no print has been generated, return to the standard output.
    if(output == "") do
      path = Path.join(:code.priv_dir(:honey), "BPF_Boilerplates/OutputFunc.c")
      decl = "void output();\n"
      {decl, File.read!(path)}
    else
      #Else, add the prefix and the suffix to the output.
      module_name = Utils.module_name(env)
      prefix = """
        void output(struct #{module_name}_bpf* skel) {
          int key, success;
          Generic value = (Generic){0};
      """
      suffix = """
              sleep(1);
            }
          }
      """
      decl = "void output(struct #{module_name}_bpf* skel);\n"

      {decl, prefix <> output <> suffix}
    end
  end

  @doc """
  Adds the needed includes for eBPF.
  """

  def default_includes() do
    gen("""
    #include <linux/bpf.h>
    #include <bpf/bpf_helpers.h>
    #include <stdlib.h>
    #include <runtime_structures.bpf.h>
    #include <runtime_functions.bpf.c>

    """)
  end

  def dependant_includes(config) do
    case config.libbpf_prog_type do
      "xdp_traffic_count" ->
        gen("""
        #include <linux/if_ether.h>
        #include <linux/ip.h>
        #include <linux/icmp.h>
        """)
      _ -> ""
    end
  end

  @doc """
  Adds the default includes to the ones specified in config.
  """

  def generate_includes(config) do
    default_includes() <> dependant_includes(config)
  end

  @doc """
  Generate the C version of the maps declared by the user in Elixir.
  """

  def generate_maps(%Boilerplates{elixir_maps: maps}) do
    c_maps =
      Enum.map(maps, fn elixir_map ->
        map_name = elixir_map[:name]
        map_content = elixir_map[:content]

        fields =
          Enum.map(map_content, fn {key, value} ->
            case key do
              :type ->

                "__uint(#{key}, #{Macro.to_string(value)});"

              :max_entries ->
                "__uint(#{key}, #{Integer.to_string(value)});"

              _ ->
                ""
            end
          end)
          |> Enum.join("\n")

        """
        struct {
          #{fields}
          #{if(map_content.type == BPF_MAP_TYPE_ARRAY or map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY) do
            "__uint(key_size, sizeof(int));"
          else
            "__uint(key_size, sizeof(long));"
          end}
          __uint(value_size, sizeof(Generic));
        } #{map_name} SEC(".maps");
        """
      end)

    Enum.join(c_maps, "\n") <> "\n"
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
  Prepares the main method to operate normally.
  """

  def beginning_main_code do
    gen("""
    StrFormatSpec str_param1;
    StrFormatSpec str_param2;
    StrFormatSpec str_param3;

    OpResult op_result = (OpResult){0};

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

    unsigned (*tuple_pool)[TUPLE_POOL_SIZE] = bpf_map_lookup_elem(&tuple_pool_map, &zero);
    if (!tuple_pool)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\"};
      goto CATCH;
    }

    unsigned *tuple_pool_index = bpf_map_lookup_elem(&tuple_pool_index_map, &zero);
    if (!tuple_pool_index)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = \"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\"};
      goto CATCH;
    }
    *tuple_pool_index = 0;
    """)
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
  Creates the struct for the ctx main argument.
  """

  def generate_ctx_struct(config) do
    case config.libbpf_prog_type do
    "tracepoint/syscalls/sys_enter_kill" -> gen("""
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
    """)

    "tracepoint/raw_syscalls/sys_enter" -> gen("""
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
    """)

    "tracepoint/syscalls/sys_enter_write" -> gen("""
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
    """)

    _ -> gen("")
    end
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
        "syscalls_enter_kill_args *ctx_arg"

      "tracepoint/raw_syscalls/sys_enter" ->
        "syscalls_enter_args *ctx_arg"

      "tracepoint/syscalls/sys_enter_write" ->
        "syscalls_enter_write_args *ctx_arg"

      "xdp_traffic_count" ->
        "struct xdp_md *ctx_arg"
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
      // =============== beginning of user code ===============
      #{config.translated_code.code}
      // =============== end of user code ==============
      #{generate_ending_main_code(config.translated_code.return_var_name)}
    }
    """)
  end
end
