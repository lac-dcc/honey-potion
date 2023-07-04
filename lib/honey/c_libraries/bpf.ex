defmodule Honey.Bpf_helpers do
  import Honey.CoreElixirToC, only: [generate_c_tuple_from_variables: 1]
  import Honey.Utils, only: [gen: 1]
  alias Honey.{FunctionData, FunctionArgument, ElixirType, CLibrary}
  use CLibrary

  def bpf_printk(_str) do
    arguments = [FunctionArgument.new("str", ElixirType.type_bitstring())]
    return_type = ElixirType.type_integer()
    FunctionData.new("bpf_printk", arguments, return_type)
  end

  def bpf_get_current_pid_tgid() do
  end

  def bpf_map_lookup_elem(_map, _key) do
  end

  def bpf_map_update_elem(_map, _key, _value) do
  end

  def bpf_map_update_elem(_map, _key, _value, _flags) do
  end

  def custom_ast_to_c({{:., _, [Honey.Bpf_helpers, function]}, _, params}, context) do
    case function do
      :bpf_printk ->
        [[string | other_params]] = params

        if !is_bitstring(string) do
          raise "First argument of bpf_printk must be a string. Received: #{Macro.to_string(params)}"
        end

        string = String.replace(string, "\n", "\\n")
        code_vars = Enum.map(other_params, &Translator.honeys_ast_to_c(&1, context))

        code = Enum.reduce(code_vars, "", fn %{code: code}, so_far -> so_far <> code end)

        vars =
          Enum.reduce(code_vars, "", fn translated, so_far ->
            so_far <> ", " <> translated.return_var_name <> ".value.integer"
          end)

        result_var = Translator.unique_helper_var()

        # TODO: Instead of returning 0, return the actual result of the call to bpf_printk
        """
        #{code}
        bpf_printk(\"#{string}\"#{vars});
        Generic #{result_var} = {.type = INTEGER, .value.integer = 0};
        """
        |> gen()
        |> TranslatedCode.new(result_var)

      :bpf_map_lookup_elem ->
        [map_name, key_ast] = params

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

        found_var = Translator.unique_helper_var()
        item_var = Translator.unique_helper_var()

        str_map_name = Atom.to_string(map_name)

        key = Translator.honeys_ast_to_c(key_ast, context)

        result_var_pointer = Translator.unique_helper_var()
        result_var = Translator.unique_helper_var()

        cond do
          map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY or
              map_content.type == BPF_MAP_TYPE_ARRAY ->
            tuple_translation = generate_c_tuple_from_variables([found_var, item_var])

            """
            #{key.code}
            if(#{key.return_var_name}.type != INTEGER) {
              op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Key passed to bpf_map_lookup_elem is not integer."};
              goto CATCH;
            }
            Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer));

            Generic #{result_var} = (Generic){.type = INTEGER, .value.integer = 0};

            Generic #{found_var} = #{result_var_pointer} ? ATOM_TRUE : ATOM_FALSE;
            Generic #{item_var} = (Generic){0};
            if(!#{result_var_pointer}) {
              // #{item_var} = ATOM_NIL;
              op_result = (OpResult){.exception = 1, .exception_msg = "(KeyNotFound) The key provided was not found in the map '#{str_map_name}'."};
              goto CATCH;
            } else {
              #{item_var} = *#{result_var_pointer};
              #{item_var}.type = #{item_var}.type == INVALID_TYPE ? INTEGER : #{item_var}.type;
            }
            /* #{tuple_translation.code} */
            """
            |> gen()
            # |> TranslatedCode.new(tuple_translation.return_var_name)
            |> TranslatedCode.new(item_var)

          true ->
            raise "bpf_map_lookup_elem: In this verison of Honey Potion, we cannot use this function with map type #{map_content.type}."
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

        key = Translator.honeys_ast_to_c(key_ast, context)
        value = Translator.honeys_ast_to_c(value_ast, context)

        result_var_c = Translator.unique_helper_var()
        result_var = Translator.unique_helper_var()

        cond do
          map_content.type == BPF_MAP_TYPE_PERCPU_ARRAY or
            map_content.type == BPF_MAP_TYPE_ARRAY or
            map_content.type == BPF_MAP_TYPE_PERCPU_HASH or
              map_content.type == BPF_MAP_TYPE_HASH ->
            """
            #{key.code}
            #{value.code}
            if(#{key.return_var_name}.type != INTEGER) {
              op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
              goto CATCH;
            }
            int #{result_var_c} = bpf_map_update_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer), &#{value.return_var_name}, #{flags_str});
            Generic #{result_var} = (Generic){.type = INTEGER, .value.integer = #{result_var_c}};
            """
            |> gen()
            |> TranslatedCode.new(result_var)

          true ->
            raise "bpf_map_update_elem: In this verison of Honey Potion, we cannot use this function with map type #{map_content.type}."
        end

      :bpf_get_current_pid_tgid ->
        result_var = Translator.unique_helper_var()

        "Generic #{result_var} = {.type = INTEGER, .value.integer = bpf_get_current_pid_tgid()};\n"
        |> gen()
        |> TranslatedCode.new(result_var)
    end
  end

end
