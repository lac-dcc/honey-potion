defmodule Honey.Translator do
  alias Honey.Boilerplates
  alias Honey.TranslatedCode
  alias Honey.Guard

  import Honey.Utils, only: [gen: 1, var_to_string: 1, ctx_var_to_generic: 1, is_var: 1]

  @moduledoc """
  Translates the elixir AST into eBPF readable C code.
  """

  @doc """
  #Translates the main function.
  """

  def translate(func_name, ast, sec, license, requires, elixir_maps) do
    case func_name do
      "main" ->
        Guard.ensure_sec_type!(sec)
        translated_code = to_c(ast)

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
  def to_c({var, var_meta, var_context}, _context) when is_atom(var) and is_atom(var_context) do
    c_var_name = var_to_string({var, var_meta, var_context})
    TranslatedCode.new("", c_var_name)
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
  def to_c(ast = {{:., _, [:erlang, function]}, _, [constant]}, _context) when is_integer(constant) do
    IO.inspect(ast)
    case function do
      :- -> {:ok, code} = constant_to_code(0-constant); code
      _ -> raise "Erlang function not supported: \"#{Atom.to_string(function)}#{constant}\""
    end
  end

  def to_c({{:., _, [:erlang, function]}, _, [lhs, rhs]}, _context) do
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

    lhs_in_c = to_c(lhs)
    rhs_in_c = to_c(rhs)
    c_var_name = unique_helper_var()

    """
    #{lhs_in_c.code}
    #{rhs_in_c.code}
    BINARY_OPERATION(#{c_var_name}, #{func_string}, #{lhs_in_c.return_var_name}, #{rhs_in_c.return_var_name})
    """
    |> gen()
    |> TranslatedCode.new(c_var_name)
  end

  # C libraries
  def to_c({{:., _, [Honey.Bpf_helpers, function]}, _, params}, context) do
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
            so_far<>", "<>translated.return_var_name <> ".value.integer"
          end)

        result_var = unique_helper_var()

        # TODO: Instead of returning 0, return the actual result of the call to bpf_printk
        """
        #{code}
        bpf_printk(\"#{string}\"#{vars});
        Generic #{result_var} = {.type = INTEGER, .value.integer = 0};
        """
        |> gen()
        |> TranslatedCode.new(result_var)

      # TODO: Maps stopped working after the addition of dynamic types.
      :bpf_map_lookup_elem ->
        [map, key_ast] = params

        if !is_atom(map) do
          raise "bpf_map_lookup_elem: 'map' must be an atom. Received: #{Macro.to_string(map)}"
        end

        str_map_name = Atom.to_string(map)

        key = to_c(key_ast, context)

        result_var_pointer = unique_helper_var()
        result_var = unique_helper_var()

        """
        #{key.code}
        if(#{key.return_var_name}.type != INTEGER) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_lookup_elem is not integer."};
          goto CATCH;
        }
        Generic *#{result_var_pointer} = bpf_map_lookup_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer));
        if(!#{result_var_pointer}) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MapAcess) Impossible to access map '#{str_map_name}' with the key informed."};
          goto CATCH;
        }
        Generic #{result_var} = *#{result_var_pointer};
        """
        |> gen()
        |> TranslatedCode.new(result_var)

      :bpf_map_update_elem ->
        [map, key_ast, value_ast] = params

        if !is_atom(map) do
          raise "bpf_map_update_elem: 'map' must be an atom. Received: #{Macro.to_string(map)}"
        end

        str_map_name = Atom.to_string(map)

        # if(!is_atom(flags)) do
        #   throw "bpf_map_update_elem: 'flags' must be an atom. Received: #{Macro.to_string(map)}"
        # end
        # flags_map_name = Atom.to_string(flags)
        # |> String.replace("Elixir.", "")

        key = to_c(key_ast, context)
        value = to_c(value_ast, context)

        result_var_c = unique_helper_var()
        result_var = unique_helper_var()

        """
        #{key.code}
        #{value.code}
        if(#{key.return_var_name}.type != INTEGER) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MapKey) Keys passed to bpf_map_update_elem is not integer."};
          goto CATCH;
        }
        int #{result_var_c} = bpf_map_update_elem(&#{str_map_name}, &(#{key.return_var_name}.value.integer), &#{value.return_var_name}, BPF_ANY);
        Generic #{result_var} = (Generic){.type = INTEGER, .value.integer = #{result_var_c}};
        """
        |> gen()
        |> TranslatedCode.new(result_var)

      :bpf_get_current_pid_tgid ->
        result_var = unique_helper_var()

        "Generic #{result_var} = {.type = INTEGER, .value.integer = bpf_get_current_pid_tgid()};\n"
        |> gen()
        |> TranslatedCode.new(result_var)
    end
  end

  # Here for future possibility of global variables. Incomplete.
  def to_c({{:., _, [Honey.Bpf.Global, function]}, _, _params}, _context) do
    case function do
      :create -> "" #Creates a global variable in the front end. Translated elsewhere.
      :set -> "" #Sets the value in the front-end before calling the program, translated elsewhere here.
      :get -> "" #Gets the value set in the front-end, has to be translated here.
      func -> raise "Honey.Bpf.Global does not have " <> to_string(func) <> "as a valid function."
    end
  end

  # Dot operator to access ctx_arg
  def to_c({{:., _, [{:ctx, _var_meta, var_context}, element]}, _, _}, _context) when is_atom(var_context) do
    generic_name = ctx_var_to_generic(element)
    TranslatedCode.new("", generic_name)
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
  def to_c({:cond, _, [[do: conds]]}, _context) do
    cond_var = unique_helper_var()

    cond_code = cond_statments_to_c(conds, cond_var)

    """
    Generic #{cond_var} = {.type = INTEGER, .value.integer = 0};
    #{cond_code}
    """
    |> gen()
    |> TranslatedCode.new(cond_var)
  end

  def to_c({:{}, _, tuple_values}, _context) when is_list(tuple_values) do
    tuple_values_to_c = Enum.map(tuple_values, fn element -> to_c(element) end)
    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap(tuple_values_to_c, 0)
    tuple_values_code = Enum.reduce(tuple_values_to_c, "", fn tuple_to_c, acc -> (acc <> "\n" <> tuple_to_c.code) end)

    tuple_var = unique_helper_var()
    """
    #{tuple_values_code}
    #{heap_allocation_code}
    Generic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
  end

  def to_c({first_element, second_element}, _context) do
    first_element_c_code = to_c(first_element)
    second_element_c_code = to_c(second_element)
    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap([first_element_c_code, second_element_c_code], 0)

    tuple_var = unique_helper_var()
    """
    #{first_element_c_code.code}
    #{second_element_c_code.code}
    #{heap_allocation_code}
    Generic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
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

    list_tail_in_c.code
    <>
    list_header_in_c.code
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  def to_c([first_element | tail], context) do
    list_tail_in_c = to_c(tail, context)
    list_header_in_c = allocate_list_header_into_heap(first_element)

    list_tail_in_c.code
    <>
    list_header_in_c.code
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  # Case
  def to_c({:case, _, [case_input, [do: cases]]} = _case_exp, _context) do
    case_input_translated = to_c(case_input)
    case_return_var = unique_helper_var()

    case_code = case_statements_to_c(case_input_translated.return_var_name,
                                     case_return_var,
                                     cases)

    """
    #{case_input_translated.code}
    Generic #{case_return_var};
    #{case_code}
    """
    |> gen()
    |> TranslatedCode.new(case_return_var)
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
  def to_c({:=, _, [lhs, rhs]}, _context, raise_exception) do
    exit_label = unique_helper_label()
    rhs_in_c = to_c(rhs)

    pattern_matching_code =
      """
      #{rhs_in_c.code}
      op_result.exception = 0;
      #{pattern_matching(lhs, rhs_in_c.return_var_name, exit_label)}
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
    |> TranslatedCode.new(rhs_in_c.return_var_name)
  end

  defp allocate_tuple_in_heap([], index) do
    code =
    """
    *heap_index += #{index};
    *tuple_pool_index += #{index};
    """
    {code, index}
  end

  defp allocate_tuple_in_heap([translated_code_var | tail], index) do
    code =
      """
      if(*heap_index < (HEAP_SIZE-#{index})) {
        (*heap)[(*heap_index)+#{index}] = #{translated_code_var.return_var_name};
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
    {next_code, allocated_size} = allocate_tuple_in_heap(tail, index+1)
    {code <> next_code, allocated_size}
  end

  def allocate_list_header_into_heap(header_element) do
    list_element_in_c = to_c(header_element)
    list_var = unique_helper_var()

    list_element_in_c.code
    <>
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
      (*heap)[(*heap_index)] = #{list_element_in_c.return_var_name};
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
    """
    |> gen()
    |> TranslatedCode.new(list_var)
  end

  defp generate_code_for_list_head_element_assignment(list_head_var_name, assignment_head, exit_label) do
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
    """
    <>
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

  defp get_list_elements_from_heap(list_head_var_name, [assignment_head | assignments_tail], exit_label) do
    head_element_code = generate_code_for_list_head_element_assignment(list_head_var_name, assignment_head, exit_label)
    next_list_header = generate_code_for_get_next_list_head(list_head_var_name, exit_label)

    head_element_code
    <>
    next_list_header.code
    <>
    get_list_elements_from_heap(next_list_header.return_var_name, assignments_tail, exit_label)
  end

  defp get_tuple_element_from_heap(_tuple_var_name, [], _index, _exit_label), do: ""

  defp get_tuple_element_from_heap(tuple_var_name, [first_tuple_elm | tail], index, exit_label) do
    first_tuple_elm_name = unique_helper_var()
    heap_index_var_name = unique_helper_var()
    """
    Generic #{first_tuple_elm_name};
    if(#{tuple_var_name}.value.tuple.start + #{index} < TUPLE_POOL_SIZE && #{tuple_var_name}.value.tuple.start + #{index}>= 0) {
      unsigned #{heap_index_var_name} = *((*tuple_pool)+(#{tuple_var_name}.value.tuple.start + #{index}));
      if(#{heap_index_var_name} < HEAP_SIZE && #{heap_index_var_name} >= 0) {
        #{first_tuple_elm_name} = *(*(heap)+(#{heap_index_var_name}));
      } else {
        op_result = (OpResult){.exception = 1, .exception_msg = "HEAP(MatchError) No match of right hand side value."};
        goto #{exit_label};
      }
    } else {
      op_result = (OpResult){.exception = 1, .exception_msg = "TUPLE(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
      <>
    pattern_matching(first_tuple_elm, first_tuple_elm_name, exit_label)
      <>
    get_tuple_element_from_heap(tuple_var_name, tail, index+1, exit_label)
  end

  defp pattern_matching({:_, _meta, _} = var, _helper_var_name, _exit_label) when is_var(var), do: ""

  defp pattern_matching({:{}, _meta, tuple_elements}, helper_var_name, exit_label) when is_list(tuple_elements) do
    """
    if(#{helper_var_name}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    <>
    get_tuple_element_from_heap(helper_var_name, tuple_elements, 0, exit_label)
  end

  defp pattern_matching({first, second}, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    <>
    get_tuple_element_from_heap(helper_var_name, [first, second], 0, exit_label)
  end

  defp pattern_matching([{:|, _meta, [header_assignment, tail_assignments]}], helper_var_name, exit_label) do
    head_element_code = generate_code_for_list_head_element_assignment(helper_var_name, header_assignment, exit_label)
    next_list_header = generate_code_for_get_next_list_head(helper_var_name, exit_label)

    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    <>
    head_element_code
    <>
    next_list_header.code
    <>
    pattern_matching(tail_assignments, next_list_header.return_var_name, exit_label)
  end

  defp pattern_matching(list_handlers, helper_var_name, exit_label) when is_list(list_handlers) do
    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
    <>
    get_list_elements_from_heap(helper_var_name, list_handlers, exit_label)
  end

  defp pattern_matching(var, helper_var_name, _exit_label) when is_var(var) do
    c_var_name = var_to_string(var)
    """
    Generic #{c_var_name} = #{helper_var_name};
    """
  end

  defp pattern_matching(:true, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 8 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(:false, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 3 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(:nil, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 0 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(constant, helper_var_name, exit_label) when is_integer(constant) do
    """
    if(#{helper_var_name}.type != INTEGER || #{constant} != #{helper_var_name}.value.integer) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(constant, helper_var_name, exit_label) when is_bitstring(constant) do
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
    """
    <>
    generate_bitstring_checker_at_position(constant, string_var_name, 0, exit_label)
  end

  # Compare if a given constant string `constant` is equals to a given variable by checking
  # chars one by one.
  defp generate_bitstring_checker_at_position("", _string_var_name, _index, _exit_label), do: ""

  defp generate_bitstring_checker_at_position(constant, string_var_name, index, exit_label) when is_bitstring(constant) do
    if (String.length(constant) <= index) do
      ""
    else
      """
      if(#{string_var_name}.start < STRING_POOL_SIZE - #{index} && #{string_var_name}.start >= 0) {
        if(\'#{String.at(constant, index)}\' != *((*string_pool)+(#{string_var_name}.start + #{index}))) {
          op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
          goto #{exit_label};
        }
      }
      """
      <>
      generate_bitstring_checker_at_position(constant, string_var_name, index+1, exit_label)
    end
  end

  defp case_statements_to_c(_case_input_var_name, _return_var_name, []) do
    """
      op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
      goto CATCH;
    """
  end

  defp case_statements_to_c(case_input_var_name, return_var_name, [{:->, _meta, [[lhs_expression], case_code_block]} | further_cases]) do
    exit_label = unique_helper_label()
    translated_case_code_block = to_c(case_code_block)

    """
    op_result.exception = 0;
    #{pattern_matching(lhs_expression, case_input_var_name, exit_label)}
    #{exit_label}:
    if(op_result.exception == 0) {
      #{translated_case_code_block.code}
      #{return_var_name} = #{translated_case_code_block.return_var_name};
    } else {
      #{case_statements_to_c(case_input_var_name, return_var_name, further_cases)}
    }
    """
  end

  @doc """
  Translates constants into a Generic C datatype.
  Generic being a struct used to represent many different datatypes with the same type.
  """

  def constant_to_code(item) do
    var_name_in_c = unique_helper_var()

    cond do
      is_integer(item) ->
        {:ok,
         TranslatedCode.new(
           "Generic #{var_name_in_c} = {.type = INTEGER, .value.integer = #{item}};",
           var_name_in_c
         )}

      is_number(item) ->
        {:ok,
         TranslatedCode.new(
           "Generic #{var_name_in_c} = {.type = DOUBLE, .value.double_precision = #{item}};",
           var_name_in_c
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

        {:ok, TranslatedCode.new(code, var_name_in_c)}

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

  @doc """
  Transforms conditional statements to C.
  """

  #Creates a situation for when all conditions are exhausted from the method below.
  def cond_statments_to_c([], cond_var_name_in_c) do
    "#{cond_var_name_in_c} = (Generic){.type = ATOM, .value.string = (String){0, 2}};"
  end

  #Transforms conditional statements to C one condition at a time.
  def cond_statments_to_c([cond_stat | other_conds], cond_var_name_in_c) do
    {:->, _, [[condition] | [block]]} = cond_stat
    condition_in_c = to_c(condition)

    block_in_c = to_c(block)

    gen("""
    #{condition_in_c.code}
    if (to_bool(&#{condition_in_c.return_var_name})) {
      #{block_in_c.code}
      #{cond_var_name_in_c} = #{block_in_c.return_var_name};
    } else {
      #{cond_statments_to_c(other_conds, cond_var_name_in_c)}
    }
    """)
  end


  #Translates a block of code by calling to_c for each element in that block.
  defp block_to_c({:__block__, _, exprs}, context) do
    Enum.reduce(exprs, Honey.TranslatedCode.new(), fn expr, translated_so_far ->
      translated_expr = to_c(expr, context)

      %TranslatedCode{
        translated_expr
        | code: translated_so_far.code <> "\n" <> translated_expr.code
      }
    end)
  end

end
