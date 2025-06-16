defmodule Honey.Compiler.TranslatorContext do
  defstruct [:maps]

  def new(maps) do
    %__MODULE__{maps: maps}
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

  import Honey.Utils.Core, only: [gen: 1, var_to_string: 1, is_var: 1]

  @doc """
  #Translates the main function.
  """
  def translate(func_name, ast, sec, license, requires, elixir_maps) do
    case func_name do
      "main" ->
        Guard.ensure_sec_type!(sec)
        context = Honey.Compiler.TranslatorContext.new(elixir_maps)
        translated_code = to_c(ast, context)

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
  Translates specific segments of the AST to C.
  """
  def to_c(tree, context \\ {})

  # Variables
  def to_c(var, _context) when is_var(var) do
    c_var_name = var_to_string(var)
    c_var_type = TypeSet.get_typeset_from_var_ast(var)
    TranslatedCode.new("", c_var_name, c_var_type)
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
  def to_c({{:., _, [:erlang, function]}, _, [constant]}, _context)
      when is_integer(constant) do
    case function do
      :- ->
        {:ok, code} = constant_to_code(0 - constant)
        code

      _ ->
        raise "Erlang function not supported: \"#{Atom.to_string(function)}#{constant}\""
    end
  end

  def to_c({{:., _, [:erlang, function]}, _, [lhs, rhs]}, context) do
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

        :> ->
          "GreaterThan"

        :< ->
          "LessThan"

        # :>= ->
        #   " ... "
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
    rhs_in_c = to_c(rhs, context)
    c_var_name = unique_helper_var()

    c_var = typed_binary_operation(lhs_in_c, rhs_in_c, c_var_name, func_string, function)

    """
    #{lhs_in_c.code}
    #{rhs_in_c.code}
    #{c_var.code}
    """
    |> gen()
    |> TranslatedCode.new(c_var.return_var_name, c_var.return_var_type)
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
        code_vars = Enum.map(other_params, &to_c(&1, context))

        code = Enum.reduce(code_vars, "", fn %{code: code}, so_far -> so_far <> code end)

        vars =
          Enum.reduce(code_vars, "", fn translated, so_far ->
            if TypeSet.is_generic?(translated.return_var_type) do
              so_far <> ", " <> translated.return_var_name <> ".value.integer"
            else
              if TypeSet.is_integer?(translated.return_var_type) do
                so_far <> ", " <> translated.return_var_name
              else
                # TODO: This should handle CTX variables somehow. Currently (?) they get a type of :type_ctx_pid.
                so_far <> ", " <> translated.return_var_name <> ".value.integer"
              end
            end
          end)

        result_var = unique_helper_var()

        # TODO: Instead of returning 0, return the actual result of the call to bpf_printk
        """
        #{code}
        bpf_printk(\"#{string}\"#{vars});
        int #{result_var} = 0;
        """
        |> gen()
        |> TranslatedCode.new(result_var, TypeSet.new(ElixirTypes.type_integer()))

      :bpf_ktime_get_ns ->
        result_var = unique_helper_var()

        """
        int #{result_var} = bpf_ktime_get_ns();
        """
        |> gen()
        |> TranslatedCode.new(result_var, TypeSet.new(ElixirTypes.type_integer()))

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

            key_code =
              cond do
                TypeSet.has_unique_type(key.return_var_type, ElixirTypes.type_void()) ->
                  """
                  #{key.code}
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, #{key.return_var_name});
                  """

                TypeSet.is_integer?(key.return_var_type) ->
                  """
                  #{key.code}\n
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key.return_var_name}));
                  """

                TypeSet.is_generic?(key.return_var_type) ->
                  """
                  #{key.code}
                  if(#{key.return_var_name}.type != INTEGER) {
                    op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
                    goto CATCH;
                  }
                  Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer));
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

            (key_code <>
               """
               int #{item_var};
               if(!#{result_var_pointer}) {
               #{not_found_code}
               } else {
                 #{item_var} = #{result_var_pointer}->value.integer;
               }
               """)
            |> gen()
            # |> TranslatedCode.new(tuple_translation.return_var_name)
            |> TranslatedCode.new(item_var, TypeSet.new(ElixirTypes.type_integer()))

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
        value = to_c(value_ast, context)
        generic_value = translated_code_to_generic(value)

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
            #{value.code}
            #{generic_value.code}
            """

            update =
              cond do
                TypeSet.has_unique_type(key.return_var_type, ElixirTypes.type_void()) ->
                  """
                  #{generic_value.return_var_name}.value.integer = #{value.return_var_name};
                  int #{result_var_c} = bpf_map_update_elem(&#{str_map_name}, (#{key.return_var_name}), &#{generic_value.return_var_name}, #{flags_str});
                  """

                TypeSet.is_integer?(key.return_var_type) ->
                  """
                  #{generic_value.return_var_name}.value.integer = #{value.return_var_name};
                  int #{result_var_c} = bpf_map_update_elem(&#{str_map_name}, &(#{key.return_var_name}), &#{generic_value.return_var_name}, #{flags_str});
                  """

                true ->
                  """
                  if(#{key.return_var_name}.type != INTEGER) {
                    op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
                    goto CATCH;
                  }
                  int #{result_var_c} = bpf_map_update_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer), &#{generic_value.return_var_name}, #{flags_str});
                  """
              end

            (start <> update)
            |> gen()
            |> TranslatedCode.new(result_var_c, TypeSet.new(ElixirTypes.type_integer()))

          true ->
            raise "bpf_map_update_elem: In this verison of Honey Potion, we cannot use this function with map type #{map_content.type}."
        end

      :bpf_get_current_pid_tgid ->
        result_var = unique_helper_var()

        "int #{result_var} = bpf_get_current_pid_tgid();\n"
        |> gen()
        |> TranslatedCode.new(result_var, TypeSet.new(ElixirTypes.type_integer()))
    end
  end

  # TODO: Move some of the Ethhdr to a better name.
  def to_c({{:., _, [Honey.Ethhdr, function]}, _, params}, _context) do
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
        |> TranslatedCode.new("", TypeSet.new(ElixirTypes.type_invalid()))

      # We don't need code to initialize a constant.
      :const_udp ->
        "" |> TranslatedCode.new("IPPROTO_UDP", TypeSet.new(ElixirTypes.type_integer()))

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
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_integer()))

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
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_integer()))

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
        |> TranslatedCode.new(port_var.return_var_name, TypeSet.new(ElixirTypes.type_integer()))

      :h_source ->
        """
        void* #{return_var} = eth->h_source;

        if (#{return_var} == 0) return XDP_PASS;
        if (#{return_var} + 7 >= data_end) return XDP_PASS;

        """
        |> gen()
        |> TranslatedCode.new(return_var, TypeSet.new(ElixirTypes.type_void()))
    end
  end

  def to_c({{:., _, [Honey.XDP, function]}, _, _params}, _context) do
    case function do
      :drop ->
        """
        return XDP_DROP;
        """
        |> gen()
        |> TranslatedCode.new("XDP_DROP", TypeSet.new(ElixirTypes.type_integer()))

      :pass ->
        """
        return XDP_PASS;
        """
        |> gen()
        |> TranslatedCode.new("XDP_PASS", TypeSet.new(ElixirTypes.type_integer()))
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
  def to_c({{:., _, [{:ctx, _var_meta, var_context}, element]}, access_meta, _}, _context)
      when is_atom(var_context) do
    access_type = Keyword.get(access_meta, :types, TypeSet.new(ElixirTypes.type_any()))
    helper_var = unique_helper_var()

    cond do
      TypeSet.is_integer?(access_type) ->
        """
        int #{helper_var} = ctx_arg->#{element};
        """
        |> gen()
        |> TranslatedCode.new(helper_var, TypeSet.new(ElixirTypes.type_integer()))

      TypeSet.is_generic?(access_type) ->
        """
        Generic #{helper_var} = {.type = INTEGER, .value.integer = ctx_arg->#{element}};
        """
        |> gen()
        |> TranslatedCode.new(helper_var, TypeSet.new(ElixirTypes.type_any()))
    end
  end

  # General dot operator
  def to_c({{:., _, [var, property]}, _, _}, _context) do
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
    |> TranslatedCode.new(property_var)
  end

  # function raise/1
  def to_c({:raise, _meta, [msg]}, _context) when is_bitstring(msg) do
    new_var_name = unique_helper_var()

    """
    Generic #{new_var_name} = (Generic){0};
    op_result = (OpResult){ .exception = 1, .exception_msg = \"(RaiseException) #{msg}\"};
    goto CATCH;
    """
    |> gen()
    |> TranslatedCode.new(new_var_name)
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
    |> TranslatedCode.new(cond_var)
  end

  def to_c({:{}, _, tuple_values}, _context) when is_list(tuple_values) do
    tuple_translations_to_c = Enum.map(tuple_values, fn element -> to_c(element) end)

    generic_tuple_elements =
      Enum.map(tuple_translations_to_c, fn element -> translated_code_to_generic(element) end)

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
    |> TranslatedCode.new(tuple_var)
  end

  def to_c({first_element, second_element}, context) do
    to_c({:{}, [], [first_element, second_element]}, context)
  end

  def to_c([], _context) do
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
    |> TranslatedCode.new(list_var)
  end

  def to_c([{:|, _meta, [head_element, tail_assignments]}], context) do
    list_tail_in_c = to_c(tail_assignments, context)
    list_header_in_c = allocate_list_header_into_heap(head_element)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  def to_c([first_element | tail], context) do
    list_tail_in_c = to_c(tail, context)
    list_header_in_c = allocate_list_header_into_heap(first_element)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  # Case
  def to_c({:case, _, [case_input, [do: cases]]} = _case_exp, _context) do
    case_input_translated = to_c(case_input)

    # We might not get a generic. We want a generic to operate on Case, as Case can have any type:
    generic_case_input = translated_code_to_generic(case_input_translated)
    case_return_var = unique_helper_var()

    case_code =
      case_statements_to_c(
        generic_case_input.return_var_name,
        case_return_var,
        cases
      )

    """
    #{case_input_translated.code}
    #{generic_case_input.code}
    Generic #{case_return_var};
    #{case_code}
    """
    |> gen()
    |> TranslatedCode.new(case_return_var, TypeSet.new(ElixirTypes.type_any()))
  end

  # Other structures
  def to_c(other, _context) do
    case constant_to_code(other) do
      {:ok, code} ->
        code

      _ ->
        IO.puts("We cannot convert this structure yet:")
        IO.inspect(other)
        raise "We cannot convert this structure yet."
    end
  end

  # Match operator, not complete
  def to_c({:=, _, [lhs, rhs]}, context, raise_exception) do
    exit_label = unique_helper_label()
    rhs_in_c = to_c(rhs, context)
    # This section assumes that var = block means that var is generic.
    # If this code ever breaks, that is likely why.
    return_rhs =
      case rhs do
        {:__block__, _, _} ->
          if TypeSet.is_generic?(rhs_in_c.return_var_type) do
            TranslatedCode.new("", rhs_in_c.return_var_name, rhs_in_c.return_var_type)
          else
            translated_code_to_generic(rhs_in_c)
          end

        _ ->
          TranslatedCode.new("", rhs_in_c.return_var_name, rhs_in_c.return_var_type)
      end

    pattern_matching_code = """
    #{rhs_in_c.code}
    #{return_rhs.code}
    op_result.exception = 0;
    #{pattern_matching(lhs, return_rhs.return_var_name, exit_label)}
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
    |> TranslatedCode.new(return_rhs.return_var_name)
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

  def allocate_list_header_into_heap(header_element) do
    list_element_in_c = to_c(header_element)
    generic_list_element = translated_code_to_generic(list_element_in_c)
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
         exit_label
       ) do
    head_element_var_name = unique_helper_var()
    heap_index_var_name = unique_helper_var()

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
    """ <>
      pattern_matching(assignment_head, head_element_var_name, exit_label)
  end

  defp generate_code_for_get_next_list_head(list_head_var_name, exit_label) do
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
    |> TranslatedCode.new(next_list_head_var_name)
  end

  defp get_list_elements_from_heap(list_head_var_name, [], exit_label) do
    """
    if(#{list_head_var_name}.value.tuple.start != -1 || #{list_head_var_name}.value.tuple.end != -1) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp get_list_elements_from_heap(
         list_head_var_name,
         [assignment_head | assignments_tail],
         exit_label
       ) do
    head_element_code =
      generate_code_for_list_head_element_assignment(
        list_head_var_name,
        assignment_head,
        exit_label
      )

    next_list_header = generate_code_for_get_next_list_head(list_head_var_name, exit_label)

    head_element_code <>
      next_list_header.code <>
      get_list_elements_from_heap(next_list_header.return_var_name, assignments_tail, exit_label)
  end

  defp get_tuple_element_from_heap(_tuple_var_name, [], _index, _exit_label), do: ""

  defp get_tuple_element_from_heap(tuple_var_name, [first_tuple_elm | tail], index, exit_label) do
    rhs_var = unique_helper_var()
    heap_index_var_name = unique_helper_var()

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
    """ <>
      if is_var(first_tuple_elm) and
           not TypeSet.is_generic?(TypeSet.get_typeset_from_var_ast(first_tuple_elm)) do
        lhs_var_type = TypeSet.get_typeset_from_var_ast(first_tuple_elm)
        typed_rhs = unique_helper_var()
        # TODO: Add type verification before grabbing rhs_var and go to exit label
        cond do
          TypeSet.is_integer?(lhs_var_type) ->
            """
            int #{typed_rhs} = #{rhs_var}.value.integer;
            """ <>
              pattern_matching(first_tuple_elm, typed_rhs, exit_label) <>
              get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label)

          TypeSet.is_string?(lhs_var_type) ->
            """
            STRING #{typed_rhs} = {rhs_var}.vale.string;
            """

            pattern_matching(first_tuple_elm, typed_rhs, exit_label) <>
              get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label)

          true ->
            raise "TODO"
        end
      else
        pattern_matching(first_tuple_elm, rhs_var, exit_label, true) <>
          get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label)
      end
  end

  defp pattern_matching(segment, var_name, exit_label, generic \\ false)

  defp pattern_matching({:_, _meta, _} = var, _helper_var_name, _exit_label, _generic)
       when is_var(var),
       do: ""

  defp pattern_matching({:{}, _meta, tuple_elements}, helper_var_name, exit_label, _generic)
       when is_list(tuple_elements) do
    """
    if(#{helper_var_name}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      get_tuple_element_from_heap(helper_var_name, tuple_elements, 0, exit_label)
  end

  defp pattern_matching({first, second}, helper_var_name, exit_label, _generic) do
    """
    if(#{helper_var_name}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      get_tuple_element_from_heap(helper_var_name, [first, second], 0, exit_label)
  end

  defp pattern_matching(
         [{:|, _meta, [header_assignment, tail_assignments]}],
         helper_var_name,
         exit_label,
         _generic
       ) do
    head_element_code =
      generate_code_for_list_head_element_assignment(
        helper_var_name,
        header_assignment,
        exit_label
      )

    next_list_header = generate_code_for_get_next_list_head(helper_var_name, exit_label)

    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      head_element_code <>
      next_list_header.code <>
      pattern_matching(tail_assignments, next_list_header.return_var_name, exit_label)
  end

  defp pattern_matching(list_handlers, helper_var_name, exit_label, _generic)
       when is_list(list_handlers) do
    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      get_list_elements_from_heap(helper_var_name, list_handlers, exit_label)
  end

  defp pattern_matching(var, helper_var_name, _exit_label, generic) when is_var(var) do
    c_var_name = var_to_string(var)

    # Check variable type, if has 1 type, it's that type, else it's generic. Generic flag nullifies this.
    var_typeset = TypeSet.get_typeset_from_var_ast(var)

    if generic do
      """
      Generic #{c_var_name} = #{helper_var_name};
      """
    else
      cond do
        TypeSet.is_integer?(var_typeset) ->
          """
          int #{c_var_name} = #{helper_var_name};
          """

        TypeSet.is_string?(var_typeset) ->
          """
          String #{c_var_name} = #{helper_var_name};
          """

        TypeSet.has_unique_type(var_typeset, ElixirTypes.type_binary()) ->
          """
          String #{c_var_name} = #{helper_var_name};
          """

        TypeSet.has_unique_type(var_typeset, ElixirTypes.type_void()) ->
          """
          void* #{c_var_name} = #{helper_var_name};
          """

        # TODO: Other types.
        true ->
          """
          Generic #{c_var_name} = #{helper_var_name};
          """
      end
    end
  end

  defp pattern_matching(true, helper_var_name, exit_label, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 8 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(false, helper_var_name, exit_label, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 3 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(nil, helper_var_name, exit_label, _generic) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 0 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(constant, helper_var_name, exit_label, generic)
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
  end

  defp pattern_matching(constant, helper_var_name, exit_label, generic)
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
    else
      "" <> generate_bitstring_checker_at_position(constant, helper_var_name, 0, exit_label)
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

  defp case_statements_to_c(_case_input_var_name, _return_var_name, []) do
    """
      op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
      goto CATCH;
    """
  end

  defp case_statements_to_c(case_input_var_name, return_var_name, [
         {:->, _meta, [[lhs_expression], case_code_block]} | further_cases
       ]) do
    exit_label = unique_helper_label()
    translated_case_code_block = to_c(case_code_block)

    generic_translated_case = translated_code_to_generic(translated_case_code_block)

    """
    op_result.exception = 0;
    #{pattern_matching(lhs_expression, case_input_var_name, exit_label, true)}
    #{exit_label}:
    if(op_result.exception == 0) {
      #{translated_case_code_block.code}
      #{generic_translated_case.code}
      #{return_var_name} = #{generic_translated_case.return_var_name};
    } else {
      #{case_statements_to_c(case_input_var_name, return_var_name, further_cases)}
    }
    """
  end

  @doc """
  Translates constants into a Generic C datatype.
  Generic being a struct used to represent many different datatypes with the same type.
  """

  def constant_to_code(item, generic \\ false)

  def constant_to_code(item, false) do
    var_name_in_c = unique_helper_var()

    cond do
      is_integer(item) ->
        {:ok,
         TranslatedCode.new(
           "int #{var_name_in_c} = #{item};",
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_integer())
         )}

      is_number(item) ->
        {:ok,
         TranslatedCode.new(
           "Generic #{var_name_in_c} = {.type = DOUBLE, .value.double_precision = #{item}};",
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_float())
         )}

      # Considering only strings for now
      is_bitstring(item) ->
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
          unsigned #{len_var_name} = #{str_len};
          unsigned #{end_var_name} = *string_pool_index + #{len_var_name} - 1;
          if(#{end_var_name} + 1 >= STRING_POOL_SIZE) {
            op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
            goto CATCH;
          }

          if(*string_pool_index < STRING_POOL_SIZE - #{len_var_name}) {
            __builtin_memcpy(&(*string_pool)[*string_pool_index], "#{str}", #{len_var_name});
          }

          String #{var_name_in_c} = (String){.start = *string_pool_index, .end = #{end_var_name}};
          *string_pool_index = #{end_var_name} + 1;
          """)

        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_bitstring()))}

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

        code = "Generic #{var_name_in_c} = #{value};"
        {:ok, TranslatedCode.new(code, var_name_in_c)}

      is_binary(item) ->
        raise "We cannot convert binary yet."

      # TODO: create an option for tuples and arrays

      true ->
        :error
    end
  end

  def constant_to_code(item, true) do
    var_name_in_c = unique_helper_var()

    cond do
      is_integer(item) ->
        {:ok,
         TranslatedCode.new(
           "Generic #{var_name_in_c} = {.type = INTEGER, .value.integer = #{item}};",
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_any())
         )}

      is_number(item) ->
        {:ok,
         TranslatedCode.new(
           "Generic #{var_name_in_c} = {.type = DOUBLE, .value.double_precision = #{item}};",
           var_name_in_c,
           TypeSet.new(ElixirTypes.type_any())
         )}

      # Considering only strings for now
      is_bitstring(item) ->
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
          unsigned #{len_var_name} = #{str_len};
          unsigned #{end_var_name} = *string_pool_index + #{len_var_name} - 1;
          if(#{end_var_name} + 1 >= STRING_POOL_SIZE) {
            op_result = (OpResult){.exception = 1, .exception_msg = "(MemoryLimitReached) Impossible to create string, the string pool is full."};
            goto CATCH;
          }

          if(*string_pool_index < STRING_POOL_SIZE - #{len_var_name}) {
            __builtin_memcpy(&(*string_pool)[*string_pool_index], "#{str}", #{len_var_name});
          }

          Generic #{var_name_in_c} = {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = #{end_var_name}}};
          *string_pool_index = #{end_var_name} + 1;
          """)

        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_any()))}

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

        code = "Generic #{var_name_in_c} = #{value};"
        {:ok, TranslatedCode.new(code, var_name_in_c, TypeSet.new(ElixirTypes.type_any()))}

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
    generic_block = translated_code_to_generic(block_in_c)

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
    Enum.reduce(exprs, Honey.Runtime.TranslatedCode.new(), fn expr, translated_so_far ->
      translated_expr = to_c(expr, context)

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

  def typed_binary_operation(lhs_in_c, rhs_in_c, return_name, func_string, function) do
    cond do
      # LHS is generic
      TypeSet.is_generic?(lhs_in_c.return_var_type) ->
        # RHS is generic, we do a BINARY_OPERATION.
        if TypeSet.is_generic?(rhs_in_c.return_var_type) do
          "BINARY_OPERATION(#{return_name}, #{func_string}, #{lhs_in_c.return_var_name}, #{rhs_in_c.return_var_name})"
          |> gen()
          |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()))

          # RHS isn't generic, we need to get it to generic
        else
          generic_rhs = translated_code_to_generic(rhs_in_c)

          """
          #{generic_rhs.code}
          BINARY_OPERATION(#{return_name}, #{func_string}, #{lhs_in_c.return_var_name}, #{generic_rhs.return_var_name})
          """
          |> gen()
          |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()))
        end

      # RHS is generic and lhs isn't
      TypeSet.is_generic?(rhs_in_c.return_var_type) ->
        generic_lhs = translated_code_to_generic(lhs_in_c)

        """
        #{generic_lhs.code}
        BINARY_OPERATION(#{return_name}, #{func_string}, #{generic_lhs.return_var_name}, #{rhs_in_c.return_var_name})
        """
        |> gen()
        |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()))

      # Generics have been dealt with. Time to consider the rest.
      TypeSet.is_integer?(lhs_in_c.return_var_type) and
          TypeSet.is_integer?(rhs_in_c.return_var_type) ->
        case function do
          :== ->
            """
            Generic #{return_name};
            if (#{lhs_in_c.return_var_name} == #{rhs_in_c.return_var_name}){
              #{return_name} = ATOM_TRUE;
            } else {
              #{return_name} = ATOM_FALSE;
            }
            """
            |> gen()
            |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_any()))

          _ ->
            "int #{return_name} = #{lhs_in_c.return_var_name} #{function} #{rhs_in_c.return_var_name};"
            |> gen()
            |> TranslatedCode.new(return_name, TypeSet.new(ElixirTypes.type_integer()))
        end

      true ->
        raise "We can't do a typed operation between #{lhs_in_c.return_var_name} and #{rhs_in_c.return_var_name}."
    end
  end

  defp translated_code_to_generic(typed_var) do
    if TypeSet.is_generic?(typed_var.return_var_type) do
      "" |> TranslatedCode.new(typed_var.return_var_name)
    else
      generic_var = unique_helper_var()

      cond do
        TypeSet.is_integer?(typed_var.return_var_type) ->
          """
           Generic #{generic_var} = {0};
           #{generic_var}.type = INTEGER; #{generic_var}.value.integer = #{typed_var.return_var_name};
          """

        TypeSet.has_unique_type(typed_var.return_var_type, ElixirTypes.type_boolean()) ->
          raise "TODO"

        TypeSet.is_string?(typed_var.return_var_type) ->
          """
            Generic #{generic_var} = {0};
            #{generic_var}.type = STRING; #{generic_var}.value.string = #{typed_var.return_var_name};
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
      |> TranslatedCode.new(generic_var, TypeSet.new(ElixirTypes.type_any()))
    end
  end
end
