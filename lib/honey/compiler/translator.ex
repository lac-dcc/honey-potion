defmodule Honey.Compiler.TranslatorContext do
  defstruct [:maps, :free_memory_blocks, :var_pointer_map]

  def new(maps, free_memory_blocks, var_pointer_map) do
    %__MODULE__{maps: maps, free_memory_blocks: free_memory_blocks, var_pointer_map: var_pointer_map}
  end
end

defmodule Honey.Compiler.Translator do
  @moduledoc """
  Translates the elixir AST into eBPF readable C code.
  """
  alias Honey.Codegen.Boilerplates
  alias Honey.Utils.Guard
  alias Honey.Analysis.ElixirTypes
  alias Honey.Runtime.TranslatedCode
  alias Honey.TypeSet
  alias Honey.Runtime.MemoryBlocks

  import Honey.Utils.Core, only: [gen: 1, var_to_string: 1, is_var: 1]

  @doc """
  #Translates the main function.
  """
  def translate(func_name, ast, sec, license, requires, elixir_maps) do
    case func_name do
      "main" ->
        Guard.ensure_sec_type!(sec)
        context = Honey.Compiler.TranslatorContext.new(elixir_maps, MemoryBlocks.create(4096), %{})
        #IO.inspect(context)
        translated_code = to_c(ast, context)
        IO.inspect(translated_code)

        sec
        |> Boilerplates.config(["ctx0nil"], license, elixir_maps, requires, translated_code)
        |> Boilerplates.generate_whole_code()

      _ ->
        false
    end
  end

  @doc """
  Generates a string with the format "helper_var_<UniqueNumber>" to be used as an unique variable.
  """
  def unique_helper_var() do
    "helper_var_#{:erlang.unique_integer([:positive])}"
  end

  def unique_helper_label() do
    "label_#{:erlang.unique_integer([:positive])}"
  end

  @doc """
  Gets a variable's value representation in the stack by pointer dereferencing.
  """
  def get_var_stack_name(translated_code) do
    #IO.inspect("Searching in")
    #IO.inspect(translated_code)
    #IO.inspect(Map.get(translated_code.context.var_pointer_map, translated_code.return_var_name))

    elem = Map.get(translated_code.context.var_pointer_map, translated_code.return_var_name)
    c_var_position = case elem do 
      {pos, _} -> pos
      {pos, _, _} -> pos 
    end

    if TypeSet.is_generic?(translated_code.return_var_type) do
      "(*(Generic*) (stack + #{c_var_position}))"
    else
      if TypeSet.is_integer?(translated_code.return_var_type) do
      "(*(int*) (stack + #{c_var_position}))"
      else
        # TODO: This should handle CTX variables somehow. Currently (?) they get a type of :type_ctx_pid.
      "(*(Generic*) (stack + #{c_var_position}))"
      end
    end
  end

  def allocate_var_in_context(context, var_name_in_c, size) do
      {memory, pos} = MemoryBlocks.get(context.free_memory_blocks, size)
      context = %{ context | 
        free_memory_blocks: memory,
        var_pointer_map: Map.put(context.var_pointer_map, var_name_in_c, {pos, size})
      }
      {context, pos}
  end

  def return_var_in_context(context, var_name_in_c, keep \\ true) do
    {elem, pointer_map} = if keep do
      Map.get_and_update(context.var_pointer_map, var_name_in_c, fn current_value ->
        case current_value do
          {pos, size} -> {{pos, size}, {pos, size, :dead}}
          _ -> {current_value, current_value}
        end
      end)
    else
      Map.pop(context.var_pointer_map, var_name_in_c)
    end
   
    case elem do
      nil -> context
      {pos, size} -> 
        memory = MemoryBlocks.give(context.free_memory_blocks, pos, size)
        %{ context | 
          free_memory_blocks: memory,
          var_pointer_map: pointer_map 
        }
      {_, _, :dead} -> 
        %{ context | 
          var_pointer_map: pointer_map 
        }
    end
  end

  def deallocate_var_in_context(context, meta, var_name_in_c) do
    IO.inspect("Removing")
    IO.inspect(var_name_in_c)
    if String.match?(var_name_in_c, ~r/^helper_var_/) do
      IO.inspect("Helper")
      return_var_in_context(context, var_name_in_c)
    else
      dv = Keyword.get(meta, :dv)
      if MapSet.member?(dv, String.to_atom(var_name_in_c)) do
        IO.inspect("Dead")
        return_var_in_context(context, var_name_in_c)
      else
        case Keyword.get(meta, :last) do
          true -> IO.inspect("Last")
            IO.inspect(meta)
            return_var_in_context(context, var_name_in_c)
          _ -> context
        end
      end
    end
  end

  @doc """
  Translates specific segments of the AST to C.
  """
  def to_c(tree, context \\ {})

  # Variables
  def to_c({_, _meta, _} = var, context) when is_var(var) do
    c_var_name = var_to_string(var)
    #context = deallocate_var_in_context(context, meta, c_var_name)
    c_var_type = TypeSet.get_typeset_from_var_ast(var)
    TranslatedCode.new("\n//Returning variable #{c_var_name} \n", c_var_name, c_var_type, context)
  end

  # Blocks
  def to_c({:__block__, _, [expr]}, context) do
    to_c(expr, context)
  end

  def to_c({:__block__, _, _} = ast, context) do
    block = block_to_c(ast, context)
    %TranslatedCode{block | code: "\n" <> block.code <> "\n"}
  end

  # Erlang functions
  def to_c({{:., _, [:erlang, function]}, _, [constant]}, context)
      when is_integer(constant) do
    case function do
      :- ->
        {:ok, code} = constant_to_code(0 - constant, context)
        code

      _ ->
        raise "Erlang function not supported: \"#{Atom.to_string(function)}#{constant}\""
    end
  end

  def to_c({{:., meta, [:erlang, function]}, _, [lhs, rhs]}, context) do
    func_string =
      case function do
        :+ ->
          "Sum"

        :- ->
          "Subtract"

        :* ->
          "Multiply"

        :/ ->
          "Divide"

        :== ->
          "Equals"

        # :> ->
        #   " ..."

        # :>= ->
        #   " ... "

        # :< ->
        #   " ..."

        # :<= ->
        #   " ... "

        # :bsr ->
        #   " ... "

        # :bsl ->
        #   " ... "

        _ ->
          raise "Erlang function not supported: #{Atom.to_string(function)}"
      end

    lhs_in_c = to_c(lhs, context)
    rhs_in_c = to_c(rhs, lhs_in_c.context)

    # Give back variables from lhs and rhs
    c_var_name = unique_helper_var()

    c_var = typed_binary_operation(lhs_in_c, rhs_in_c, c_var_name, func_string, function, meta, rhs_in_c.context)

    """
    #{lhs_in_c.code}
    #{rhs_in_c.code}
    #{c_var.code}
    """
    |> gen()
    |> TranslatedCode.new(c_var.return_var_name, c_var.return_var_type, c_var.context)
  end

  # C libraries
  def to_c({{:., _, [Honey.BpfHelpers, function]}, _, params}, context) do
    case function do
      :bpf_printk ->
        [[string | other_params]] = params

        if !is_bitstring(string) do
          raise "First argument of bpf_printk must be a string. Received: #{Macro.to_string(params)}"
        end

        string = String.replace(string, "\n", "\\n")
        {code_vars, _final_context} = Enum.map_reduce(other_params, context, &{to_c(&1, &2), &2})

        code = Enum.reduce(code_vars, "", fn %{code: code}, so_far -> so_far <> code end)

        #        vars =
        #          Enum.reduce(code_vars, "", fn translated, so_far ->
        #            if TypeSet.is_generic?(translated.return_var_type) do
        #              so_far <> ", " <> translated.return_var_name <> ".value.integer"
        #            else
        #              if TypeSet.is_integer?(translated.return_var_type) do
        #                so_far <> ", " <> translated.return_var_name
        #              else
        #                # TODO: This should handle CTX variables somehow. Currently (?) they get a type of :type_ctx_pid.
        #                so_far <> ", " <> translated.return_var_name <> ".value.integer"
        #              end
        #            end
        #          end)

        vars =
          Enum.reduce(code_vars, "", fn translated, so_far ->
            if TypeSet.is_generic?(translated.return_var_type) do
              so_far <> ", " <> get_var_stack_name(translated) <> ".value.integer"
            else
              if TypeSet.is_integer?(translated.return_var_type) do
                so_far <> ", " <> get_var_stack_name(translated)
              else
                # TODO: This should handle CTX variables somehow. Currently (?) they get a type of :type_ctx_pid.
                so_far <> ", " <> get_var_stack_name(translated) <> ".value.integer"
              end
            end
          end)
        result_var = unique_helper_var()

        {context, pos} = allocate_var_in_context(context, result_var, 4)

        # TODO: Instead of returning 0, return the actual result of the call to bpf_printk
        """
        #{code}
        bpf_printk(\"#{string}\"#{vars});

        // Defining variable #{result_var};
        stack_int = (int*) (stack + #{pos});
        stack_int[0] = 0;
        """
        |> gen()
        |> TranslatedCode.new(result_var, TypeSet.new(ElixirTypes.type_integer()), context)

      :bpf_map_lookup_elem ->
        params =
          case params do
            [map_name, key_ast] -> [map_name, key_ast, :panic]
            _ -> params
          end

        [map_name, key_ast, default_value] = params

        if !is_atom(map_name) do
          raise "bpf_map_lookup_elem: 'map' must be an atom. Received: #{Macro.to_string(map_name)}"
        end

        declared_maps = context.maps

        map =
          Enum.find(declared_maps, nil, fn map ->
            map[:name] == map_name
          end)

        if(!map) do
          raise "bpf_map_update_elem: No map declared with name #{map_name}."
        end

        map_content = map[:content]

        item_var = unique_helper_var()
        # found_var = unique_helper_var()

        str_map_name = Atom.to_string(map_name)

        key = to_c(key_ast, context)
        context = key.context

        result_var_pointer = unique_helper_var()

        cond do
          map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY or
            map_content.type == BPF_MAP_TYPE_ARRAY or
            map_content.type == BPF_MAP_TYPE_PERCPU_HASH or
              map_content.type == BPF_MAP_TYPE_HASH ->
            # This used to be commented in the end of the translated code. I decided to remove it to reduce clutter.
            # tuple_translation = generate_c_tuple_from_variables([found_var, item_var])

            # I am going to temporarely assume that everything that is stored in a map is an integer.
            # This assumption should be broken eventually and it should be done within this cond.

            key_in_stack = get_var_stack_name(key)

            key_code =
              cond do
                TypeSet.has_unique_type(key.return_var_type, ElixirTypes.type_void()) ->
                  """
                  #{key.code}
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, #{key_in_stack});
                  """

                TypeSet.is_integer?(key.return_var_type) ->
                  """
                  #{key.code}\n
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key_in_stack}));
                  """

                TypeSet.is_generic?(key.return_var_type) ->
                  """
                  #{key.code}
                  if(#{key.return_var_name}.type != INTEGER) {
                    op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
                    goto CATCH;
                  }
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key_in_stack}.value.integer));
                  """
              end

            not_found_code =
              if default_value == :panic do
                """
                  op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map '#{str_map_name}'."};
                  goto CATCH;
                """
              else
                # Here the assumption that maps keeps ints is also maintained. 
                default_value_translated = to_c(default_value)

                """
                  #{default_value_translated.code}
                  #{item_var} = #{default_value_translated.return_var_name};
                """
              end
              {context, pos} = allocate_var_in_context(context, item_var, 4)
            (key_code <>
               """
               //Getting #{item_var}
               if(!#{result_var_pointer}) {
               #{not_found_code}
               } else {
                 stack_int = (int*) (stack + #{pos});
                 stack_int[0] = #{result_var_pointer}->value.integer;
               }
               """)
            |> gen()
            # |> TranslatedCode.new(tuple_translation.return_var_name)
            |> TranslatedCode.new(item_var, TypeSet.new(ElixirTypes.type_integer()), context)

          # Ideally this will return a tuple with two values: A boolean representing whether the value was found
          # and the value itself (:nil if it wasn't found).
          # At this moment however, I'm having trouble because 1) Storing the value in a stack variable is only
          # being possible if I stop the program when the key isn't found and 2) The pattern matching for
          # tuples seems bugged.
          # So currently, the program throws an exception if the key is not found and only returns the value
          # as a single variable. But I'm commeting some code to make it easier to convert it to the the original
          # idea once it's possible.

          true ->
            raise "bpf_map_lookup_elem: In this verison of Honey Potion, we cannot use this function with map type #{map_content.type}."
            #   case Map.fetch(map_content, :key_type) do
            #     {:ok, key_type} ->
            #       case key_type[:type] do
            #         :string ->
            #           """
            #           #{key.code}
            #           if(#{key.return_var_name}.type != STRING) {
            #             op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not a string."};
            #             goto CATCH;
            #           }
            #           if(#{key.return_var_name}.value.string.end - #{key.return_var_name}.value.string.start + 1 < #{key_type[:size]}) {
            #             op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) String passed to bpf_map_lookup_elem is not long enough for key of size #{key_type[:size]}."};
            #             goto CATCH;
            #           }
            #           if(#{key.return_var_name}.value.string.start >= STRING_POOL_SIZE - #{key_type[:size]}) {
            #             op_result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (function bpf_map_lookup_elem)."};
            #             goto CATCH;
            #           }
            #           Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, (*string_pool) + #{key.return_var_name}.value.string.start);

            #           Generic #{result_var} = (Generic){.type = INTEGER, .value.integer = 0}; // This is a fake variable, necessary while we still need to return a var name.

            #           Generic #{found_var_name} = (Generic){0};
            #           Generic #{item_var_name} = (Generic){0};
            #           if(!#{result_var_pointer}) {
            #             #{found_var_name} = ATOM_FALSE;
            #             #{item_var_name} = ATOM_NIL;
            #           } else {
            #             #{found_var_name} = ATOM_TRUE;
            #             #{item_var_name} = *#{result_var_pointer};
            #           }
            #           """
            #           |> gen()
            #           |> TranslatedCode.new(result_var)
            #       end
            #   end
        end

      :bpf_map_update_elem ->
        [map_name, key_ast, value_ast, flags] =
          case params do
            [map_name, key_ast, value_ast] ->
              [map_name, key_ast, value_ast, :BPF_ANY]

            [_map_name, _key_ast, _value_ast, _flags] ->
              params
          end

        if !is_atom(map_name) do
          raise "bpf_map_update_elem: 'map' must be an atom. Received: #{Macro.to_string(map_name)}"
        end

        declared_maps = context.maps

        map =
          Enum.find(declared_maps, nil, fn map ->
            map[:name] == map_name
          end)

        if(!map) do
          raise "bpf_map_update_elem: No map declared with name #{map_name}."
        end

        map_content = map[:content]

        str_map_name = Atom.to_string(map_name)

        if(!is_atom(flags)) do
          throw("bpf_map_update_elem: 'flags' must be an atom. Received: #{Macro.to_string(map)}")
        end

        flags_str =
          Atom.to_string(flags)
          |> String.replace("Elixir.", "")

        key = to_c(key_ast, context)
        update_value = to_c(value_ast, key.context)
        generic_value = translated_code_to_generic(update_value, update_value.context)
        context = key.context

        result_var_c = unique_helper_var()

        cond do
          # I am going to temporarely assume that everything that is stored in a map is an integer.
          # This assumption should be broken eventually and it should be done within this cond.

          map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY or
            map_content.type == BPF_MAP_TYPE_ARRAY or
            map_content.type == BPF_MAP_TYPE_PERCPU_HASH or
              map_content.type == BPF_MAP_TYPE_HASH ->
            start = """
            #{key.code}
            #{update_value.code}
            #{generic_value.code}
            """
            key_in_stack = get_var_stack_name(key)
            generic_value_in_stack = get_var_stack_name(generic_value)
            update_value_in_stack = get_var_stack_name(update_value)

            {context, pos} = allocate_var_in_context(context, result_var_c, 4)

            update =
              cond do
                TypeSet.has_unique_type(key.return_var_type, ElixirTypes.type_void()) ->
                  """
                  #{generic_value_in_stack}.value.integer = #{update_value_in_stack};
                  stack_int = (int*) (stack + #{pos});
                  stack_int[0] = bpf_map_update_elem(&#{str_map_name}, (#{key_in_stack}), &#{generic_value_in_stack}, #{flags_str});
                  """

                TypeSet.is_integer?(key.return_var_type) ->
                  """
                  #{generic_value_in_stack}.value.integer = #{update_value_in_stack};
                  stack_int = (int*) (stack + #{pos});
                  stack_int[0] = bpf_map_update_elem(&#{str_map_name}, &(#{key_in_stack}), &#{generic_value_in_stack}, #{flags_str});
                  """

                true ->
                  """
                  if(#{key_in_stack}.type != INTEGER) {
                    op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
                    goto CATCH;
                  }
                  stack_int = (int*) (stack + #{pos});
                  stack_int[0] = bpf_map_update_elem(&#{str_map_name}, &(#{key_in_stack}), &#{generic_value_in_stack}, #{flags_str});
                  """
              end

            (start <> update)
            |> gen()
            |> TranslatedCode.new(result_var_c, TypeSet.new(ElixirTypes.type_integer()), context)

          true ->
            raise "bpf_map_update_elem: In this verison of Honey Potion, we cannot use this function with map type #{map_content.type}."
        end

      :bpf_get_current_pid_tgid ->
        result_var = unique_helper_var()

        "int #{result_var} = bpf_get_current_pid_tgid();\n"
        |> gen()
        |> TranslatedCode.new(result_var, TypeSet.new(ElixirTypes.type_integer()), context)
    end
  end

  # TODO: Move some of the Ethhdr to a better name.
  def to_c({{:., _, [Honey.Ethhdr, function]}, _, params}, context) do
    return_var = unique_helper_var()

    case function do
      :init ->
        """
        void *data_end = (void *)(long)ctx_arg->data_end;
        void *data = (void *)(long)ctx_arg->data;
        struct ethhdr *eth = data;

        __u64 nh_off = sizeof(*eth);

        if (data + nh_off > data_end)
        return XDP_ABORTED;
        """
        |> gen()
        |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_invalid()), context)

      # We don't need code to initialize a constant.
      :const_udp ->
        "" |> TranslatedCode.new("IPPROTO_UDP", TypeSet.new(ElixirTypes.type_integer()), context)

      :ip_protocol ->
        """
        int #{return_var};
        if (eth->h_proto == htons(ETH_P_IP)){
            struct iphdr *iph = data + nh_off;

            // Again verifier check our boundary checks
            if (data + nh_off + sizeof(struct iphdr) > data_end)
                return 0;

            nh_off += sizeof(struct iphdr);
            #{return_var} = iph->protocol;
        } else if (eth->h_proto == htons(ETH_P_IPV6)) {

            struct ipv6hdr *ip6h = data + nh_off;

            // Again verifier check our boundary checks
            if (data + nh_off + sizeof(struct ipv6hdr) > data_end)
                return 0;

            nh_off += sizeof(struct ipv6hdr);
            #{return_var} = ip6h->nexthdr;
        } else {
            return XDP_PASS;
        }
        """
        |> gen()
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_integer()), context)

      :destination_port ->
        """
        int #{return_var};
        {
        struct udphdr *udph = data + nh_off;

        if (data + nh_off + sizeof(struct udphdr) > data_end)
            return 0;
        #{return_var} = ntohs(udph->dest);
        }
        """
        |> gen()
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_integer()), context)

      :set_destination_port ->
        [port] = params
        port_var = to_c(port)

        """
        #{port_var.code}
        {
        struct udphdr *udph = data + nh_off;

        if (data + nh_off + sizeof(struct udphdr) <= data_end)
            udph->dest = ntohs(#{port_var.return_var_name});
        }
        """
        |> gen()
        |> TranslatedCode.new(port_var.return_var_name, TypeSet.new(ElixirTypes.type_integer()), context)

      :h_source ->
        """
        void* #{return_var} = eth->h_source;

        if (#{return_var} == 0) return XDP_PASS;
        if (#{return_var} + 7 >= data_end) return XDP_PASS;

        """
        |> gen()
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_void()), context)
    end
  end

  def to_c({{:., _, [Honey.XDP, function]}, _, _params}, context) do
    case function do
      :drop ->
        """
        return XDP_DROP;
        """
        |> gen()
        |> TranslatedCode.new("XDP_DROP", TypeSet.new(ElixirTypes.type_integer()), context)

      :pass ->
        """
        return XDP_PASS;
        """
        |> gen()
        |> TranslatedCode.new("XDP_PASS", TypeSet.new(ElixirTypes.type_integer()), context)
    end
  end

  # Here for future possibility of global variables. Incomplete.
  def to_c({{:., _, [Honey.Bpf.Global, function]}, _, _params}, _context) do
    case function do
      # Creates a global variable in the front end. Translated elsewhere.
      :create -> ""
      # Sets the value in the front-end before calling the program, translated elsewhere here.
      :set -> ""
      # Gets the value set in the front-end, has to be translated here.
      :get -> ""
      func -> raise "Honey.Bpf.Global does not have " <> to_string(func) <> "as a valid function."
    end
  end

  # Dot operator to access ctx_arg
  def to_c({{:., _, [{:ctx, _var_meta, var_context}, element]}, access_meta, _}, context)
      when is_atom(var_context) do
    access_type = Keyword.get(access_meta, :types, TypeSet.new(ElixirTypes.type_any()))
    helper_var = unique_helper_var()

    cond do
      TypeSet.is_integer?(access_type) ->
        {context, pos} = allocate_var_in_context(context, helper_var, 4)
        """
        stack_int = (int*) (stack + #{pos});
        stack_int[0] = ctx_arg->#{element};
        """
        |> gen()
        |> TranslatedCode.new(helper_var, TypeSet.new(ElixirTypes.type_integer()), context)

      TypeSet.is_generic?(access_type) ->
        {context, pos} = allocate_var_in_context(context, helper_var, 4)
        """
        stack_gen = (Generic*) (stack + #{pos});
        stack_gen[0] = ctx_arg->#{element};
        """
        |> gen()
        |> TranslatedCode.new(helper_var, TypeSet.new(ElixirTypes.type_any()), context)
    end
  end

  # General dot operator
  def to_c({{:., _, [var, property]}, _, _}, context) do
    var_name_in_c = var_to_string(var)
    property_var = unique_helper_var()
    str_name_var = unique_helper_var()

    """
    Generic #{property_var} = {0};
    char #{str_name_var}[20] = "#{Atom.to_string(property)}";
    getMember(&op_result, &#{var_name_in_c}, #{str_name_var}, &#{property_var});
    if (op_result.exception) goto CATCH
    """
    |> gen()
    |> TranslatedCode.new(property_var, TypeSet.new(ElixirTypes.type_any()), context)
  end

  # function raise/1
  def to_c({:raise, _meta, [msg]}, context) when is_bitstring(msg) do
    new_var_name = unique_helper_var()

    """
    Generic #{new_var_name} = (Generic){0};
    op_result = (OpResult){ .exception = 1, .exception_msg = \"(RaiseException) #{msg}\"};
    goto CATCH;
    """
    |> gen()
    |> TranslatedCode.new(new_var_name, TypeSet.new(ElixirTypes.type_any()), context)
  end

  # Match
  def to_c(pm_operation = {:=, _, [_lhs, _rhs]}, context), do: to_c(pm_operation, context, true)

  # Cond
  def to_c({:cond, _, [[do: conds]]}, context) do
    cond_var = unique_helper_var()

    cond_code = cond_statments_to_c(conds, cond_var, context)

    """
    Generic #{cond_var} = {.type = INTEGER, .value.integer = 0};
    #{cond_code}
    """
    |> gen()
    |> TranslatedCode.new(cond_var, TypeSet.new(ElixirTypes.type_any()), context)
  end

  def to_c({:{}, _, tuple_values}, context) when is_list(tuple_values) do
    tuple_translations_to_c = Enum.map(tuple_values, fn element -> to_c(element) end)

    generic_tuple_elements =
      Enum.map(tuple_translations_to_c, fn element -> translated_code_to_generic(element, context) end)

    tuple_var_names =
      Enum.map(generic_tuple_elements, fn translation -> translation.return_var_name end)

    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap(tuple_var_names, 0)

    tuple_values_code =
      Enum.reduce(Enum.zip(tuple_translations_to_c, generic_tuple_elements), "", fn tuple_to_c,
                                                                                    acc ->
        {typed_translation, generic_translation} = tuple_to_c
        acc <> "\n" <> typed_translation.code <> "\n" <> generic_translation.code
      end)

    tuple_var = unique_helper_var()

    """
    #{tuple_values_code}
    #{heap_allocation_code}
    Generic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var, TypeSet.new(ElixirTypes.type_tuple()), context)
  end

  def to_c({first_element, second_element}, context) do
    to_c({:{}, [], [first_element, second_element]}, context)
  end

  def to_c([], context) do
    list_var = unique_helper_var()

    """
    Generic #{list_var} = {.type = LIST, .value.tuple = (Tuple){.start = -1, .end = -1}};
    if((*heap_index) < HEAP_SIZE && (*heap_index) >= 0) {
      (*heap)[(*heap_index)] = #{list_var};
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
      goto CATCH;
    }
    ++(*heap_index);
    """
    |> gen()
    |> TranslatedCode.new(list_var, TypeSet.new(ElixirTypes.type_any()), context)
  end

  def to_c([{:|, _meta, [head_element, tail_assignments]}], context) do
    list_tail_in_c = to_c(tail_assignments, context)
    list_header_in_c = allocate_list_header_into_heap(head_element, context)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name, TypeSet.new(ElixirTypes.type_any()), context)
  end

  def to_c([first_element | tail], context) do
    list_tail_in_c = to_c(tail, context)
    list_header_in_c = allocate_list_header_into_heap(first_element, context)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name, TypeSet.new(ElixirTypes.type_any()), context)
  end

  # Case
  def to_c({:case, _, [case_input, [do: cases]]} = _case_exp, context) do
    case_input_translated = to_c(case_input)

    # We might not get a generic. We want a generic to operate on Case, as Case can have any type:
    generic_case_input = translated_code_to_generic(case_input_translated, context)
    case_return_var = unique_helper_var()

    case_code =
      case_statements_to_c(
        generic_case_input.return_var_name,
        case_return_var,
        cases,
        context
      )

    """
    #{case_input_translated.code}
    #{generic_case_input.code}
    Generic #{case_return_var};
    #{case_code}
    """
    |> gen()
    |> TranslatedCode.new(case_return_var, TypeSet.new(ElixirTypes.type_any()), context)
  end

  # Other structures
  def to_c(other, context) do
    case constant_to_code(other, context) do
      {:ok, code} ->
        code

      _ ->
        IO.puts("We cannot convert this structure yet:")
        IO.inspect(other)
        raise "We cannot convert this structure yet."
    end
  end

  # Match operator, not complete
  def to_c({:=, meta, [lhs, rhs]}, context, raise_exception) do
    exit_label = unique_helper_label()
    rhs_in_c = to_c(rhs, context)
    # This section assumes that var = block means that var is generic.
    # If this code ever breaks, that is likely why.
    return_rhs =
      case rhs do
        {:__block__, _, _} ->
          if TypeSet.is_generic?(rhs_in_c.return_var_type) do
            TranslatedCode.new("", rhs_in_c.return_var_name, rhs_in_c.return_var_type, rhs_in_c.context)
          else
            context = return_var_in_context(rhs_in_c.context, meta, rhs_in_c)
            translated_code_to_generic(rhs_in_c, context)
          end

        _ ->
          TranslatedCode.new("", rhs_in_c.return_var_name, rhs_in_c.return_var_type, rhs_in_c.context)
      end
  
    context = return_var_in_context(context, meta, return_rhs)

    matching = pattern_matching(lhs, get_var_stack_name(return_rhs), exit_label, context)
    pattern_matching_code = """
    #{rhs_in_c.code}
    #{return_rhs.code}
    op_result.exception = 0;
    #{matching.code}
    #{exit_label}:
    """

    # `raise_exception` is a boolean parameter that defines if the pattern
    # matching operation should report an error or not if it is not possible
    # to match the expression
    exit_code =
      if(raise_exception) do
        """
        if(op_result.exception == 1) {
          goto CATCH;
        }
        """
      else
        """
        op_result = (OpResult){};
        """
      end

    (pattern_matching_code <> exit_code)
    |> gen()
    |> TranslatedCode.new(return_rhs.return_var_name, return_rhs.return_var_type, matching.context)
    #|> IO.inspect()
  end

  defp allocate_tuple_in_heap([], index) do
    code = """
    *heap_index += #{index};
    *tuple_pool_index += #{index};
    """

    {code, index}
  end

  defp allocate_tuple_in_heap([var_name | tail], index) do
    code = """
    if(*heap_index < (HEAP_SIZE-#{index})) {
      (*heap)[(*heap_index)+#{index}] = #{var_name};
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
      goto CATCH;
    }
    if(*tuple_pool_index < (TUPLE_POOL_SIZE-#{index})) {
      (*tuple_pool)[(*tuple_pool_index)+#{index}] = (*heap_index)+#{index};
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create tuple, the tuple pool is full."};
      goto CATCH;
    }
    """

    {next_code, allocated_size} = allocate_tuple_in_heap(tail, index + 1)
    {code <> next_code, allocated_size}
  end

  def allocate_list_header_into_heap(header_element, context) do
    list_element_in_c = to_c(header_element)
    generic_list_element = translated_code_to_generic(list_element_in_c, context)
    list_var = unique_helper_var()

    (list_element_in_c.code <>
       generic_list_element.code <>
       """
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

       Generic #{list_var} = (Generic){.type = LIST, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
       if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
         (*heap)[(*heap_index)] = #{generic_list_element.return_var_name};
       } else {
         op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
         goto CATCH;
       }
       ++(*heap_index);
       if(*heap_index < HEAP_SIZE && *heap_index >= 0) {
         (*heap)[(*heap_index)] = #{list_var};
       } else {
         op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to allocate memory in the heap."};
         goto CATCH;
       }
       ++(*heap_index);
       """)
    |> gen()
    |> TranslatedCode.new(list_var)
  end

  defp generate_code_for_list_head_element_assignment(
         list_head_var_name,
         assignment_head,
         exit_label,
         context
       ) do
    head_element_var_name = unique_helper_var()
    heap_index_var_name = unique_helper_var()
    
    prefix =
    """
    Generic #{head_element_var_name};
    if(#{list_head_var_name}.value.tuple.start < TUPLE_POOL_SIZE && #{list_head_var_name}.value.tuple.start >= 0) {
      unsigned #{heap_index_var_name} = *((*tuple_pool)+(#{list_head_var_name}.value.tuple.start));
      if(#{heap_index_var_name} < HEAP_SIZE && #{heap_index_var_name} >= 0) {
        #{head_element_var_name} = *(*(heap)+(#{heap_index_var_name}));
      } else {
        op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
        goto #{exit_label};
      }
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    suffix = pattern_matching(assignment_head, head_element_var_name, exit_label, context)
    %{suffix | code: prefix <> suffix.code}
  end

  defp generate_code_for_get_next_list_head(list_head_var_name, exit_label, context) do
    next_list_head_var_name = unique_helper_label()
    heap_index_var_name = unique_helper_var()

    """
    Generic #{next_list_head_var_name};
    if(#{list_head_var_name}.value.tuple.start+1 < TUPLE_POOL_SIZE && #{list_head_var_name}.value.tuple.start+1 >= 0) {
      unsigned #{heap_index_var_name} = *((*tuple_pool)+(#{list_head_var_name}.value.tuple.start+1));
      if(#{heap_index_var_name} < HEAP_SIZE && #{heap_index_var_name} >= 0) {
        #{next_list_head_var_name} = *(*(heap)+(#{heap_index_var_name}));
      } else {
        op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
        goto #{exit_label};
      }
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    |> gen()
    |> TranslatedCode.new(next_list_head_var_name, TypeSet.new(ElixirTypes.type_any()), context)
  end

  defp get_list_elements_from_heap(list_head_var_name, [], exit_label, context) do
    """
    if(#{list_head_var_name}.value.tuple.start != -1 || #{list_head_var_name}.value.tuple.end != -1) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_invalid()), context)
  end

  defp get_list_elements_from_heap(
         list_head_var_name,
         [assignment_head | assignments_tail],
         exit_label,
         context
       ) do
    head_element =
      generate_code_for_list_head_element_assignment(
        list_head_var_name,
        assignment_head,
        exit_label,
        context
      )

    next_list_header = generate_code_for_get_next_list_head(list_head_var_name, exit_label, head_element.context)

    tail_list = get_list_elements_from_heap(next_list_header.return_var_name, assignments_tail, exit_label, context)
    %{tail_list | code:
    head_element.code <>
    next_list_header.code <>
    tail_list.code}
  end

  defp get_tuple_element_from_heap(_tuple_var_name, [], _index, _exit_label, context), do: TranslatedCode.new("\n//EndOfTuple\n", "", TypeSet.new(ElixirTypes.type_any()), context)

  defp get_tuple_element_from_heap(tuple_var_name, [first_tuple_elm | tail], index, exit_label, context) do
    rhs_var = unique_helper_var()
    heap_index_var_name = unique_helper_var()
    
    prefix = 
    """
    Generic #{rhs_var};
    if(#{tuple_var_name}.value.tuple.start + #{index} < TUPLE_POOL_SIZE && #{tuple_var_name}.value.tuple.start + #{index}>= 0) {
      unsigned #{heap_index_var_name} = *((*tuple_pool)+(#{tuple_var_name}.value.tuple.start + #{index}));
      if(#{heap_index_var_name} < HEAP_SIZE && #{heap_index_var_name} >= 0) {
        #{rhs_var} = *(*(heap)+(#{heap_index_var_name}));
      } else {
        op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
        goto #{exit_label};
      }
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ 
    suffix = if is_var(first_tuple_elm) and
         not TypeSet.is_generic?(TypeSet.get_typeset_from_var_ast(first_tuple_elm)) do
      lhs_var_type = TypeSet.get_typeset_from_var_ast(first_tuple_elm)
      typed_rhs = unique_helper_var()
      # TODO: Add type verification before grabbing rhs_var and go to exit label
      cond do
        TypeSet.is_integer?(lhs_var_type) ->
          prefix = 
          """
          int #{typed_rhs} = #{rhs_var}.value.integer;
          """
          matching = pattern_matching(first_tuple_elm, typed_rhs, exit_label, context)
          tuple = get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label, matching.context)
          %{tuple | code: prefix <> matching.code <> tuple.code}

        TypeSet.is_string?(lhs_var_type) ->
          prefix = 
          """
          STRING #{typed_rhs} = {rhs_var}.vale.string;
          """

          matching = pattern_matching(first_tuple_elm, typed_rhs, exit_label, context) 
          tuple = get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label, matching.context)
          %{tuple | code: prefix <> matching.code <> tuple.code}

        true ->
          raise "TODO"
      end
    else
      matching = pattern_matching(first_tuple_elm, rhs_var, exit_label, context, true)
      tuple = get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label, matching.context)
      %{tuple | code: matching.code <> tuple.code}
    end
    %{suffix | code: prefix <> suffix.code}
  end

  defp pattern_matching(segment, helper_var_value, exit_label, context, generic \\ false)

  defp pattern_matching({:_, _meta, _} = var, _helper_var_value, _exit_label, context, _generic)
       when is_var(var),
    do: "" |> TranslatedCode.new("underscore_var",TypeSet.new(ElixirTypes.type_any()), context) 

  defp pattern_matching({:{}, _meta, tuple_elements}, helper_var_value, exit_label, context, _generic)
       when is_list(tuple_elements) do
    tuple = get_tuple_element_from_heap(helper_var_value, tuple_elements, 0, exit_label, context)
    %{tuple | code:
    """
    if(#{helper_var_value}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <> tuple.code}
  end

  defp pattern_matching({first, second}, helper_var_value, exit_label, context, _generic) do
    tuple = get_tuple_element_from_heap(helper_var_value, [first, second], 0, exit_label, context)
    %{tuple | code:
    """
    if(#{helper_var_value}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <> tuple.code}
  end

  defp pattern_matching(
         [{:|, _meta, [header_assignment, tail_assignments]}],
         helper_var_value,
         exit_label,
         context,
         _generic
       ) do
    head_element =
      generate_code_for_list_head_element_assignment(
        helper_var_value,
        header_assignment,
        exit_label,
        context
      )

    next_list_header = generate_code_for_get_next_list_head(helper_var_value, exit_label, head_element.context)

    list_tail = pattern_matching(tail_assignments, next_list_header.return_var_name, exit_label, next_list_header.context)

    %{list_tail | code:
    """
    if(#{helper_var_value}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
    head_element.code <>
    next_list_header.code <>
    list_tail.code}
  end

  defp pattern_matching(list_handlers, helper_var_name, exit_label, context, _generic)
       when is_list(list_handlers) do
    list = get_list_elements_from_heap(helper_var_name, list_handlers, exit_label, context)
    %{list | code:
    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <> list.code}
  end

  defp pattern_matching(var, helper_var_value, _exit_label, context, generic) when is_var(var) do
    c_var_name = var_to_string(var)

    # Check variable type, if has 1 type, it's that type, else it's generic. Generic flag nullifies this.
    var_typeset = TypeSet.get_typeset_from_var_ast(var)

    if generic do
      {context, pos} = allocate_var_in_context(context, c_var_name, 12)
      """
      stack_gen = (Generic*) (stack + #{pos});
      stack_gen[0] = #{helper_var_value};
      """ |> TranslatedCode.new(c_var_name, TypeSet.new(ElixirTypes.type_any()), context)
    else
      cond do
        TypeSet.is_integer?(var_typeset) ->
          {context, pos} = allocate_var_in_context(context, c_var_name, 4)
          """
          stack_int = (int*) (stack + #{pos});
          stack_int[0] = #{helper_var_value};
          """ |> TranslatedCode.new(c_var_name, TypeSet.new(ElixirTypes.type_integer()), context)

        TypeSet.is_string?(var_typeset) ->
          {context, pos} = allocate_var_in_context(context, c_var_name, 4)
          """
          stack_str = (String*) (stack + #{pos});
          stack_str[0] = #{helper_var_value};
          """ |> TranslatedCode.new(c_var_name, TypeSet.new(ElixirTypes.type_integer()), context)

        TypeSet.has_unique_type(var_typeset, ElixirTypes.type_binary()) ->
          {context, pos} = allocate_var_in_context(context, c_var_name, 4)
          """
          stack_str = (String*) (stack + #{pos});
          stack_str[0] = #{helper_var_value};
          """ |> TranslatedCode.new(c_var_name, TypeSet.new(ElixirTypes.type_integer()), context)

         #Shouldn't happen so far
#        TypeSet.has_unique_type(var_typeset, ElixirTypes.type_void()) ->
#          """
#          void* #{c_var_name} = #{helper_var_value};
#          """
#
        # TODO: Other types.
        true ->
          {context, pos} = allocate_var_in_context(context, c_var_name, 12)
          """
          stack_gen = (Generic*) (stack + #{pos});
          stack_gen[0] = #{helper_var_value};
          """ |> TranslatedCode.new(c_var_name, TypeSet.new(ElixirTypes.type_any()), context)
      end
    end
  end

  defp pattern_matching(true, helper_var_name, exit_label, context, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 8 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_any()), context)
  end

  defp pattern_matching(false, helper_var_name, exit_label, context, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 3 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_any()), context)
  end

  defp pattern_matching(nil, helper_var_name, exit_label, context, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 0 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_any()), context)
  end

  defp pattern_matching(constant, helper_var_name, exit_label, context, generic)
       when is_integer(constant) do
    if generic do
      """
      if(#{helper_var_name}.type != INTEGER || #{constant} != #{helper_var_name}.value.integer) {
        op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
        goto #{exit_label};
      }
      """
    else
      """
      """
    end
    |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_any()), context)
  end

  defp pattern_matching(constant, helper_var_name, exit_label, context, generic)
       when is_bitstring(constant) do
    if generic do
      string_var_name = unique_helper_var()

      """
        if(#{helper_var_name}.type != STRING) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
          goto #{exit_label};
        }

        String #{string_var_name} = #{helper_var_name}.value.string;
        if(#{String.length(constant)} != (#{string_var_name}.end - #{string_var_name}.start)){
          op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
          goto #{exit_label};
        }
      """ <> generate_bitstring_checker_at_position(constant, string_var_name, 0, exit_label)
      |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_invalid()), context)
    else
      "" <> generate_bitstring_checker_at_position(constant, helper_var_name, 0, exit_label)
      |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_invalid()), context)
    end
  end

  # Compare if a given constant string `constant` is equals to a given variable by checking
  # chars one by one.
  defp generate_bitstring_checker_at_position("", _string_var_name, _index, _exit_label), do: ""

  defp generate_bitstring_checker_at_position(constant, string_var_name, index, exit_label)
       when is_bitstring(constant) do
    if String.length(constant) <= index do
      ""
    else
      """
      if(#{string_var_name}.start < STRING_POOL_SIZE - #{index} && #{string_var_name}.start >= 0) {
        if(\'#{String.at(constant, index)}\' != *((*string_pool)+(#{string_var_name}.start + #{index}))) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
          goto #{exit_label};
        }
      }
      """ <>
        generate_bitstring_checker_at_position(constant, string_var_name, index + 1, exit_label)
    end
  end

  defp case_statements_to_c(_case_input_var_name, _return_var_name, [], context) do
    """
      op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
      goto CATCH;
    """
  end

  defp case_statements_to_c(case_input_var_name, return_var_name, [
         {:->, _meta, [[lhs_expression], case_code_block]} | further_cases
       ], context) do
    exit_label = unique_helper_label()
    translated_case_code_block = to_c(case_code_block)

    generic_translated_case = translated_code_to_generic(translated_case_code_block, context)

    """
    op_result.exception = 0;
    //#TODO: ADD CONTEXT
    #{pattern_matching(lhs_expression, case_input_var_name, exit_label, true)}
    #{exit_label}:
    if(op_result.exception == 0) {
      #{translated_case_code_block.code}
      #{generic_translated_case.code}
      #{return_var_name} = #{generic_translated_case.return_var_name};
    } else {
      #{case_statements_to_c(case_input_var_name, return_var_name, further_cases, context)}
    }
    """
  end

  @doc """
  Translates constants into a Generic C datatype.
  Generic being a struct used to represent many different datatypes with the same type.
  """

  def constant_to_code(item, context, generic \\ false)

  def constant_to_code(item, context, false) do
    var_name_in_c = unique_helper_var()

    cond do
      is_integer(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 4)
        {:ok,
         TranslatedCode.new(gen(
            """
              // Defining variable #{var_name_in_c};
              stack_int = (int*) (stack + #{pos});
              stack_int[0] = #{item};

            """),
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_integer()),
           context
         )}

      is_number(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 12)
        {:ok,
         TranslatedCode.new(gen(
          """
            // Defining variable #{var_name_in_c};
            stack_gen = (Generic*) (stack + #{pos});
            stack_gen[0] = #{item};

          """),
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_float()),
           context
         )}

      # Considering only strings for now
      is_bitstring(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 8)
        # TODO: Check whether the zero-termination is ok the way it is

        # TODO: consider other special chars
        # You can use `Macro.unescape_string/2` for this, but please check it
        str = String.replace(item, "\n", "\\n")
        str_len = String.length(str) + 1
        new_var_name = unique_helper_var()
        end_var_name = "end_#{new_var_name}"
        len_var_name = "len_#{new_var_name}"

        code =
          gen("""
          // Defining variable #{var_name_in_c};
          unsigned #{len_var_name} = #{str_len};
          unsigned #{end_var_name} = *string_pool_index + #{len_var_name} - 1;
          if(#{end_var_name} + 1 >= STRING_POOL_SIZE) {
            op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
            goto CATCH;
          }

          if(*string_pool_index < STRING_POOL_SIZE - #{len_var_name}) {
            __builtin_memcpy(&(*string_pool)[*string_pool_index], "#{str}", #{len_var_name});
          }
          stack_str = (String*) (stack + #{pos});
          stack_str[0] = (String){.start = *string_pool_index, .end = #{end_var_name}};

          *string_pool_index = #{end_var_name} + 1;
          """)

        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_bitstring()), context)}

      is_atom(item) ->
        # TODO: Convert arbitrary atoms
        value =
          case item do
            true ->
              "ATOM_TRUE"

            false ->
              "ATOM_FALSE"

            nil ->
              "ATOM_NIL"

            _ ->
              raise "We cannot convert arbitrary atoms yet (only 'true', 'false' and 'nil')."
          end

        {context, pos} = allocate_var_in_context(context, var_name_in_c, 8)

        code = """
          // Defining variable #{var_name_in_c};
          stack_gen = (Generic*) (stack + #{pos});
          stack_gen[0] = #{value};

        """
        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_atom()), context)}

      is_binary(item) ->
        raise "We cannot convert binary yet."

      # TODO: create an option for tuples and arrays

      true ->
        :error
    end
  end

  def constant_to_code(item, context, true) do
    var_name_in_c = unique_helper_var()

    cond do
      is_integer(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 12)
        {:ok,
         TranslatedCode.new(gen(
          """
            // Defining variable #{var_name_in_c};
            stack_gen = (Generic*) (stack + #{pos});
            stack_gen[0] = (Generic) {.type = INTEGER, .value.integer = #{item}};;

          """),
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_any()),
           context
         )}

      is_number(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 12)
        {:ok,
         TranslatedCode.new(gen(
          """
            // Defining variable #{var_name_in_c};
            stack_gen = (Generic*) (stack + #{pos});
            stack_gen[0] = (Generic)  {.type = DOUBLE, .value.double_precision = #{item}};
          """),
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_any()),
           context
         )}

      # Considering only strings for now
      is_bitstring(item) ->
        # TODO: Check whether the zero-termination is ok the way it is

        {context, pos} = allocate_var_in_context(context, var_name_in_c, 12)

        # TODO: consider other special chars
        # You can use `Macro.unescape_string/2` for this, but please check it
        str = String.replace(item, "\n", "\\n")
        str_len = String.length(str) + 1
        new_var_name = unique_helper_var()
        end_var_name = "end_#{new_var_name}"
        len_var_name = "len_#{new_var_name}"

        code =
          gen("""
          // Defining variable #{var_name_in_c};
          unsigned #{len_var_name} = #{str_len};
          unsigned #{end_var_name} = *string_pool_index + #{len_var_name} - 1;
          if(#{end_var_name} + 1 >= STRING_POOL_SIZE) {
            op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
            goto CATCH;
          }

          if(*string_pool_index < STRING_POOL_SIZE - #{len_var_name}) {
            __builtin_memcpy(&(*string_pool)[*string_pool_index], "#{str}", #{len_var_name});
          }

          stack_gen = (Generic*) (stack + #{pos});
          stack_gen[0] = (Generic) {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = #{end_var_name}}};
          *string_pool_index = #{end_var_name} + 1;
          """)

        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_any()), context)}

      is_atom(item) ->
        {context, pos} = allocate_var_in_context(context, var_name_in_c, 12)

        # TODO: Convert arbitrary atoms
        value =
          case item do
            true ->
              "ATOM_TRUE"

            false ->
              "ATOM_FALSE"

            nil ->
              "ATOM_NIL"

            _ ->
              raise "We cannot convert arbitrary atoms yet (only 'true', 'false' and 'nil')."
          end

        code = """
          stack_gen = (Generic*) (stack + #{pos});
          stack_gen[0] = (Generic) #{value};
        """
        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_any()), context)}

      is_binary(item) ->
        raise "We cannot convert binary yet."

      # TODO: create an option for tuples and arrays

      true ->
        :error
    end
  end

  @doc """
  Transforms conditional statements to C.
  """

  # Creates a situation for when all conditions are exhausted from the method below.
  def cond_statments_to_c([], cond_var_name_in_c, _context) do
    "#{cond_var_name_in_c} = (Generic){.type = ATOM, .value.string = (String){0, 2}};"
  end

  # Transforms conditional statements to C one condition at a time.
  def cond_statments_to_c([cond_stat | other_conds], cond_var_name_in_c, context) do
    {:->, _, [[condition] | [block]]} = cond_stat
    condition_in_c = to_c(condition, context)

    block_in_c = to_c(block, context)
    generic_block = translated_code_to_generic(block_in_c, context)

    if_cond =
      cond do
        TypeSet.is_integer?(condition_in_c.return_var_type) ->
          "if (#{condition_in_c.return_var_name}) {"

        TypeSet.is_generic?(condition_in_c.return_var_type) ->
          "if (to_bool(&#{condition_in_c.return_var_name})) {"
      end

    if TypeSet.is_integer?(block_in_c.return_var_type) do
      gen("""
        #{condition_in_c.code}
        #{if_cond}
        #{block_in_c.code}
        #{generic_block.code}
        #{cond_var_name_in_c} = #{generic_block.return_var_name};
      } else {
        #{cond_statments_to_c(other_conds, cond_var_name_in_c, context)}
      }
      """)
    else
      gen("""
      #{condition_in_c.code}
        #{block_in_c.code}
        #{cond_var_name_in_c} = #{block_in_c.return_var_name};
      } else {
        #{cond_statments_to_c(other_conds, cond_var_name_in_c, context)}
      }
      """)
    end
  end

  # Translates a block of code by calling to_c for each element in that block.
  defp block_to_c({:__block__, _, exprs}, context) do
    Enum.reduce(exprs, Honey.Runtime.TranslatedCode.new("", "No_Var", TypeSet.new(ElixirTypes.type_any()), context), fn expr, translated_so_far ->
      context_so_far = translated_so_far.context
      translated_expr = to_c(expr, context_so_far)

      %TranslatedCode{
        translated_expr
        | code: translated_so_far.code <> "\n" <> translated_expr.code
      }
    end)
  end

  # Receives existing variable names in the C code and generates the equivalent C code to a tuple containing the values of these variables
  def generate_c_tuple_from_variables(variable_names) do
    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap(variable_names, 0)
    tuple_var = unique_helper_var()

    """
    #{heap_allocation_code}
    Generic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
  end

  def typed_binary_operation(lhs_in_c, rhs_in_c, return_name, func_string, function, meta, context) do
    lhs_value = get_var_stack_name(lhs_in_c)
    rhs_value = get_var_stack_name(rhs_in_c)


    cond do
      # LHS is generic
      TypeSet.is_generic?(lhs_in_c.return_var_type) ->
        # RHS is generic, we do a BINARY_OPERATION.
        if TypeSet.is_generic?(rhs_in_c.return_var_type) do
          context = deallocate_var_in_context(context, meta, lhs_in_c.return_var_name)
          context = deallocate_var_in_context(context, meta, rhs_in_c.return_var_name)

          "BINARY_OPERATION(#{return_name}, #{func_string}, #{lhs_value}, #{rhs_value})"
          |> gen()
          |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()), context)

          # RHS isn't generic, we need to get it to generic
        else
          context = deallocate_var_in_context(context, meta, lhs_in_c.return_var_name)

          generic_rhs = translated_code_to_generic(rhs_in_c, context)
          generic_rhs_value = get_var_stack_name(generic_rhs)

          context = deallocate_var_in_context(generic_rhs.context, meta, rhs_in_c.return_var_name)

          """
          #{generic_rhs.code}
          BINARY_OPERATION(#{return_name}, #{func_string}, #{lhs_value}, #{generic_rhs_value})
          """
          |> gen()
          |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()), context)
        end

      # RHS is generic and lhs isn't
      TypeSet.is_generic?(rhs_in_c.return_var_type) ->
        context = deallocate_var_in_context(context, meta, rhs_in_c.return_var_name)

        generic_lhs = translated_code_to_generic(lhs_in_c, context)
        generic_lhs_value = get_var_stack_name(generic_lhs)

        context = deallocate_var_in_context(generic_lhs.context, meta, lhs_in_c.return_var_name)
        """
        #{generic_lhs.code}
        BINARY_OPERATION(#{return_name}, #{func_string}, #{generic_lhs_value}, #{rhs_value})
        """
        |> gen()
        |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()), context)

      # Generics have been dealt with. Time to consider the rest.
      TypeSet.is_integer?(lhs_in_c.return_var_type) and
          TypeSet.is_integer?(rhs_in_c.return_var_type) ->
        context = deallocate_var_in_context(context, meta, lhs_in_c.return_var_name)
        context = deallocate_var_in_context(context, meta, rhs_in_c.return_var_name)
        case function do
          :== ->
            {context, pos} = allocate_var_in_context(context, return_name, 12)
            """
            stack_gen = (Generic*) (stack + #{pos});
            if (#{lhs_value} == #{rhs_value}){
              stack_gen[0] = ATOM_TRUE;
            } else {
              stack_gen[0] = ATOM_FALSE;
            }
            """
            |> gen()
            |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()), context)

          _ ->
            {context, pos} = allocate_var_in_context(context, return_name, 4)
            """
            stack_int = (int*) (stack + #{pos});
            stack_int[0] = #{lhs_value} #{function} #{rhs_value};
            """
            |> gen()
            |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_integer()), context)
        end

      true ->
        raise "We can't do a typed operation between #{lhs_in_c.return_var_name} and #{rhs_in_c.return_var_name}."
    end
  end

  defp translated_code_to_generic(typed_var, context) do
    if TypeSet.is_generic?(typed_var.return_var_type) do
      "" |> TranslatedCode.new(typed_var.return_var_name, typed_var.return_var_type, context)
    else
      generic_var = unique_helper_var()

      {context, pos} = allocate_var_in_context(context, generic_var, 12)
      typed_var_value = get_var_stack_name(typed_var)
      cond do
        TypeSet.is_integer?(typed_var.return_var_type) ->
          """
            // Defining variable #{generic_var};
            stack_gen = (Generic*) (stack + #{pos});
            stack_gen[0] = (Generic){.type = INTEGER, .value.integer = #{typed_var_value}};
          """

        TypeSet.has_unique_type(typed_var.return_var_type, ElixirTypes.type_boolean()) ->
          raise "TODO"

        TypeSet.is_string?(typed_var.return_var_type) ->
          """
            // Defining variable #{generic_var};
            stack_gen = (Generic*) (stack + #{pos});
            stack_gen[0] = (Generic){.type = STRING, .value.integer = #{typed_var_value}};
          """

        TypeSet.has_unique_type(typed_var.return_var_type, ElixirTypes.type_binary()) ->
          raise "TODO"

        TypeSet.has_unique_type(typed_var.return_var_type, ElixirTypes.type_void()) ->
          raise "A void* type can't be translated to Generic. Make sure not to use it in tuples or the return of case/cond/if."

        true ->
          IO.inspect(typed_var)
          raise "TODO"
      end
      |> gen()
      |> TranslatedCode.new(generic_var, TypeSet.new(ElixirTypes.type_any()), context)
    end
  end
end
