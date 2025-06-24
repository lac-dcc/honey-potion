defmodule Honey.Codegen.Boilerplates do
  @moduledoc """
  Module for generating C boilerplate needed to translate Elixir to eBPF readable C.
  Also picks up the translated code and puts it in the appropriate section.
  """
  alias Logger.Translator
  alias Honey.Codegen.Boilerplates

  alias Honey.Compiler.Translator
  alias Honey.Analysis.ElixirTypes
  alias Honey.Runtime.Info
  alias Honey.TypeSet
  alias Honey.Utils.Core

  import Honey.Utils.Core, only: [gen: 1]

  defstruct [:libbpf_prog_type, :func_args, :license, :elixir_maps, :requires, :translated_code]

  # Keeps parameters on how the translation will be done. Set before calling generate_whole_code.
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
    module_name = Core.module_name(env)
    {_, sec, _, _} = Info.get_backend_info(env)

    include = """
    #include <bpf/bpf.h>
    #include <bpf/libbpf.h>
    #include <stdio.h>
    #include <unistd.h>
    #include <runtime_generic.bpf.h>
    #include "#{module_name}.skel.h"\n
    // xdp_md includes
    #include <net/if.h>
    #include <linux/if_link.h> 
    #include <signal.h>
    """

    boilerplate =
      case sec do
        "xdp_md" ->
          """
          static __u32 XDPFLAGS = XDP_FLAGS_SKB_MODE;
          static int IFINDEX;
          void _unloadProg(int sig) {
              bpf_xdp_attach(IFINDEX, -1, XDPFLAGS, NULL);
              printf("Unloading the eBPF program...");
              exit(0);
          }
          """

        _ ->
          ""
      end

    {chooser_decl, chooser_func} = generate_output_chooser(env)
    {output_decl, output_func} = generate_output_func_decl(env)

    main = """
    \nint main(int argc, char **argv) {

      bool printAll = false; // Prints only print:true otherwise
      uint lifeTime = 0; // If 0 -> infinite.

      int opt;
      while((opt = getopt(argc, argv, "pt:")) != -1){
        switch(opt){
          case 'p': printAll = true; break;
          case 't': lifeTime = atoi(optarg);
        }
      } 

      struct #{module_name}_bpf *skel;
      int err;

      skel = #{module_name}_bpf__open();
      if(!skel){
        fprintf(stderr, "Skeleton failed opening.\\n");
        return 1;
      }

      #{case sec do
      "xdp_md" -> """
        bpf_program__set_type(skel->progs.main_func, BPF_PROG_TYPE_XDP);
        """
      _ -> ""
    end}

      err = #{module_name}_bpf__load(skel);
      if(err){
        fprintf(stderr, "Failed loading or verification of BPF skeleton.\\n");
        #{module_name}_bpf__destroy(skel);
        return -err;
      }


      #{case sec do
      "xdp_md" -> """
        signal(SIGINT, _unloadProg);
        signal(SIGTERM , _unloadProg);

        int prog_fd = bpf_program__fd(skel->progs.main_func);

        IFINDEX = if_nametoindex("lo");
        if(bpf_xdp_attach(IFINDEX, prog_fd, XDPFLAGS, NULL) < 0){
          printf("Failed to link set xdp_fd.");
          return -1;
        }
        """
      _ -> """
        err = #{module_name}_bpf__attach(skel);
        if(err){
          fprintf(stderr, "Failed attaching BPF skeleton.\\n");
          #{module_name}_bpf__destroy(skel);
          return -err;
        }
        """
    end}

      output(skel, lifeTime, printAll);
    }\n
    """

    include <> boilerplate <> chooser_decl <> output_decl <> main <> chooser_func <> output_func
  end

  @doc """
  Creates the "output" function and gives it the functionality of choosing if everything should be output or
  only what has been requested. This is toggled by adding or removing the -p argument when calling the binary.
  """
  def generate_output_chooser(env) do
    module_name = Core.module_name(env)

    output = """
    void output(struct #{module_name}_bpf* skel, uint time, bool all){
      if(time == 0){
        while(1){
          choose_output(skel, all);
          sleep(1);
        }
      } else {
        time++;
        while(1){
          choose_output(skel, all);
          if(!--time) break;
          sleep(1);
        }
      }
    }

    void choose_output(struct #{module_name}_bpf* skel, bool all){
      if(all) output_all(skel);
      else output_opt(skel);
    }\n
    """

    decl = """
    void output(struct #{module_name}_bpf* skel, uint time, bool all);
    void choose_output(struct #{module_name}_bpf* skel, bool all);
    """

    {decl, output}
  end

  @doc """
  Return both the declarations and the functions resposible for outputting maps.
  Creates both output_opt (only what was requested) and output_all (used when -p).
  """
  def generate_output_func_decl(env) do
    output = generate_output_func(env)
    output_always = generate_output_func(env, true)

    module_name = Core.module_name(env)

    decl = "void output_opt(struct #{module_name}_bpf* skel);\n"
    decl_always = "void output_all(struct #{module_name}_bpf* skel);\n"

    {decl <> decl_always, output <> "\n" <> output_always}
  end

  @doc """
  Generates both of the output functions (output_opt and output_all).
  This takes into consideration the type of the map, what is the type of the elements inside the map,
  what elements were requested to be printed and more.
  """
  def generate_output_func(env, printAll \\ false) do
    {_, _, _, maps} = Info.get_backend_info(env)

    output =
      Enum.map(maps, fn map ->
        {name, _type, _max_entries, print, print_elem, key_size} = Info.get_maps_attributes(map)

        if(!(print == true) and !printAll) do
          ""
        else
          {printf, key_var, prev_key_var} =
            case key_size do
              :int ->
                {"""
                 printf("Entry %d: %ld\\n", key, value.value.integer);
                 """, "&key", "&#{name}_prev_key"}

              :char6 ->
                {"""
                   printf("Entry %02x:%02x:%02x:%02x:%02x:%02x: %ld\\n",
                     chkey[0], chkey[1], chkey[2], chkey[3], chkey[4], chkey[5], value.value.integer
                   );
                 """, "chkey", "#{name}_prev_key"}

              _ ->
                raise "This key_size is not supported. Try :int or :char6."
            end

          copy_code =
            case key_size do
              :int ->
                "#{name}_prev_key = key;"

              :char6 ->
                "memcpy(#{name}_prev_key, chkey, 6);"
            end

          case print_elem do
            nil ->
              """
                /* Printing map of name #{name} */
                struct bpf_map* #{name} = skel->maps.#{name};
                int #{name}_fd = bpf_map__fd(#{name});
                printf("#{name}:\\n");
                key = 0;
                #{case key_size do
                :int -> "int #{name}_prev_key = 0;"
                :char6 -> "unsigned char #{name}_prev_key[6];"
              end}
                success = bpf_map_get_next_key(#{name}_fd, NULL, #{key_var}); 
                while(success == 0){
                  success = bpf_map_lookup_elem(#{name}_fd, #{key_var}, &value);
                  if (success == 0) {
                    #{printf}
                  }
                  #{copy_code}
                  success = bpf_map_get_next_key(#{name}_fd, #{prev_key_var}, #{key_var});
                }
              """

            _ ->
              name = Atom.to_string(name)

              # Please ignore the weird intentation of the #{Enum.map}, it is needed to print with correct indentation.
              """
                /* Printing map of name #{name} */
                struct bpf_map* #{name} = skel->maps.#{name};
                int #{name}_fd = bpf_map__fd(#{name});
                printf("#{name}:\\n");
              #{Enum.map(print_elem, fn elem -> case elem do
                  {elem_name, key} when is_binary(elem_name) and is_integer(key) -> """
                        key = #{Integer.to_string(key)};
                        success = bpf_map_lookup_elem(#{name}_fd, #{key_var}, &value);
                        if(success == 0){
                          #{printf}
                        } else {
                          printf("Element %s failed to print with key %d.\\n", "#{elem_name}", #{Integer.to_string(key)});
                        }
                    """
                  _ -> raise "RuntimeError: Please specify :print_elem key with a list of tuples {name (string), key (integer)} when :print is true."
                end end) |> Enum.join()}
              """
          end
        end
      end)
      |> Enum.join()

    module_name = Core.module_name(env)

    if(printAll == false) do
      if(output == "") do
        path = Path.join(:code.priv_dir(:honey), "BPF_Boilerplates/OutputFunc.c")
        prefix = "void output_opt(struct #{module_name}_bpf* skel){"
        prefix <> File.read!(path)
      else
        prefix = """
        void output_opt(struct #{module_name}_bpf* skel) {
          int key;
          unsigned char chkey[6];
          int success;
          Generic value = (Generic){0};

          printf("\\e[1;1H\\e[2J");\n
        """

        suffix = """
        }
        """

        prefix <> output <> suffix
      end
    else
      prefix = """
      void output_all(struct #{module_name}_bpf* skel) {
        int key;
        unsigned char chkey[6];
        int success;
        Generic value = (Generic){0};

        printf("\\e[1;1H\\e[2J");\n
      """

      suffix = """
        }
      """

      prefix <> output <> suffix
    end
  end

  @doc """
  Adds the needed includes for eBPF.
  """
  def default_includes() do
    gen("""
    #include <linux/bpf.h>
    #include <bpf/bpf_helpers.h>
    #include <stddef.h>
    #include <runtime_structures.bpf.h>
    #include <runtime_functions.bpf.c>

    """)
  end

  def dependant_includes(config) do
    case config.libbpf_prog_type do
      "xdp_md" ->
        gen("""
        #include <linux/if_ether.h>
        #include <linux/ip.h>
        #include <linux/ipv6.h>
        #include <linux/icmp.h>
        #include <arpa/inet.h>
        #include <linux/udp.h>
        #include <linux/tcp.h>
        """)

      _ ->
        ""
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
        map_options = map_content[:options]

        key_size = Map.get(elixir_map, :key_size, :int)

        fields = "__uint(type, #{Macro.to_string(map_content[:type])});"

        fields =
          fields <>
            (Enum.map(map_options, fn {key, value} ->
               case key do
                 :max_entries ->
                   "__uint(#{key}, #{Integer.to_string(value)});"

                 _ ->
                   ""
               end
             end)
             |> Enum.join("\n"))

        """
        struct {
          #{fields}
          #{case key_size do
          :int -> "__uint(key_size, sizeof(int));"
          :char6 -> "__uint(key_size, sizeof(long));"
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
    int zero = 0;
    OpResult op_result = (OpResult){0};

    char(* Stack)[4096] = bpf_map_lookup_elem(&stack_map, &zero);
    if (!Stack)
    {
      op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access Stack, main function)."};
      goto CATCH;
    }

    char* stack = (char*) Stack;
    int* stack_int;
    String* stack_str;
    Generic* stack_gen;

    void* lookup;

    StrFormatSpec str_param1;
    StrFormatSpec str_param2;
    StrFormatSpec str_param3;

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
  Returns the boilerplate ending of the main function of the backend.
  """
  def generate_ending_main_code(translated_code) do
    int_type = TypeSet.new(ElixirTypes.type_integer())
    return_value = Translator.get_var_stack_name(translated_code)

    return_text =
      cond do
        translated_code.return_var_type == int_type ->
          # Inspect debug
          # IO.inspect("We returned an integer!")
          gen("""
          return #{return_value};
          """)

        TypeSet.has_type(translated_code.return_var_type, ElixirTypes.type_integer()) ->
          # Inspect debug
          IO.inspect("We can return a non-integer!; Caution.")

          gen("""
          if (#{return_value}.type != INTEGER) {
            op_result = (OpResult){.exception = 1, .exception_msg = \"(IncorrectReturn) eBPF function is not returning an integer.\"};
            goto CATCH;
          }
          return #{return_value}.value.integer;

          """)

        true ->
          # Inspect debug
          IO.inspect("Return does not have specific typing; Caution.")
          gen("""
          if (#{return_value}.type != INTEGER) {
            op_result = (OpResult){.exception = 1, .exception_msg = \"(IncorrectReturn) eBPF function is not returning an integer.\"};
            goto CATCH;
          }
          return #{return_value}.value.integer;

          """)

      end

    return_text <>
      """
      CATCH:
        bpf_printk(\"** %s\\n\", op_result.exception_msg);
        return 0;
      """
  end

  @doc """
  Creates the struct for the ctx main argument.
  """
  def generate_ctx_struct(config) do
    case config.libbpf_prog_type do
      "tracepoint/syscalls/sys_enter_kill" ->
        gen("""
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

      "tracepoint/raw_syscalls/sys_enter" ->
        gen("""
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

      "tracepoint/syscalls/sys_enter_write" ->
        gen("""
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

      _ ->
        gen("")
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

      "xdp_md" ->
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
      #{generate_ending_main_code(config.translated_code)}
    }
    """)
  end
end
