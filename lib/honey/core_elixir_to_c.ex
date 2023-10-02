defmodule Honey.CoreElixirToC do
  alias Honey.{TranslatedCode, TypeSet, Translator}

  import Honey.Utils,
    only: [ctx_var_to_generic: 1, gen: 1, var_to_string: 1, is_var: 1, is_constant: 1]

  @doc """
  Default translation of an Elixir AST to C, divided by segments. This is the default implementation,
  but any segment can be replaced by the user, Secs or C libraries implementations, which have
  priority over this default.
  """

  # Variables
  def ast_to_c({var, var_meta, var_context}, _context)
      when is_atom(var) and is_atom(var_context) do
    c_var_name = var_to_string({var, var_meta, var_context})
    TranslatedCode.new("", c_var_name)
  end

  # Blocks
  def ast_to_c({:__block__, _, [expr]}, context) do
    Translator.honeys_ast_to_c(expr, context)
  end

  def ast_to_c({:__block__, _, _} = ast, context) do
    block = block_to_c(ast, context)
    %TranslatedCode{block | code: "\n" <> block.code <> "\n"}
  end

  # Erlang functions
  def ast_to_c({{:., _, [:erlang, function]}, _, [constant]}, _context)
      when is_integer(constant) do
    case function do
      :- ->
        {:ok, code} = constant_to_code(0 - constant)
        code

      _ ->
        raise "Erlang function not supported: \"#{Atom.to_string(function)}#{constant}\""
    end
  end

  def ast_to_c({{:., _, [:erlang, function]}, _, [lhs, rhs]}, context) do
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

        # TODO :
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

    lhs_in_c = Translator.honeys_ast_to_c(lhs, context)
    rhs_in_c = Translator.honeys_ast_to_c(rhs, context)
    c_var_name = Translator.unique_helper_var()

    """
    #{lhs_in_c.code}
    #{rhs_in_c.code}
    BINARY_OPERATION(#{c_var_name}, #{func_string}, #{lhs_in_c.return_var_name}, #{rhs_in_c.return_var_name})
    """
    |> gen()
    |> TranslatedCode.new(c_var_name)
  end

  # Here for future possibility of global variables. Incomplete.
  def ast_to_c({{:., _, [Honey.Bpf.Global, function]}, _, _params}, _context) do
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

  # General dot operator
  # Let's only accept one level for now. So var.field is allowed but var.field1.field2 is not.
  #  def ast_to_c({{:., _, [var, field]}, _, _}, _context) do
  #    # TODO
  #    IO.inspect(var)
  #    IO.inspect(field)
  #    raise "Should we be using this pattern?"
  #    _typeset = TypeSet.get_typeset_from_var_ast(var)
  #  end

  def ast_to_c({{:., _, [{:ctx, _var_meta, var_context}, element]}, _, _}, _context)
      when is_atom(var_context) do
    generic_name = ctx_var_to_generic(element)
    TranslatedCode.new("", generic_name)
  end

  # function raise/1
  def ast_to_c({:raise, _meta, [msg]}, _context) when is_bitstring(msg) do
    new_var_name = Translator.unique_helper_var()

    """
    Dynamic #{new_var_name} = (Dynamic){0};
    op_result = (OpResult){ .exception = 1, .exception_msg = \"(RaiseException) #{msg}\"};
    goto CATCH;
    """
    |> gen()
    |> TranslatedCode.new(new_var_name)
  end

  # Match
  def ast_to_c(pm_operation = {:=, _, [_lhs, _rhs]}, context),
    do: match_operator_to_c(pm_operation, context)

  # Cond
  def ast_to_c({:cond, _, [[do: conds]]}, context) do
    cond_var = Translator.unique_helper_var()

    cond_code = cond_statments_to_c(conds, cond_var, context)

    """
    Dynamic #{cond_var} = {.type = INTEGER, .value.integer = 0};
    #{cond_code}
    """
    |> gen()
    |> TranslatedCode.new(cond_var)
  end

  def ast_to_c({:{}, _, tuple_values}, context) when is_list(tuple_values) do
    tuple_translations_to_c =
      Enum.map(tuple_values, fn element -> Translator.honeys_ast_to_c(element, context) end)

    tuple_var_names =
      Enum.map(tuple_translations_to_c, fn translation -> translation.return_var_name end)

    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap(tuple_var_names, 0)

    tuple_values_code =
      Enum.reduce(tuple_translations_to_c, "", fn tuple_to_c, acc ->
        acc <> "\n" <> tuple_to_c.code
      end)

    tuple_var = Translator.unique_helper_var()

    """
    #{tuple_values_code}
    #{heap_allocation_code}
    Dynamic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
  end

  def ast_to_c({first_element, second_element}, context) do
    first_element_c_code = Translator.honeys_ast_to_c(first_element, context)
    second_element_c_code = Translator.honeys_ast_to_c(second_element, context)

    {heap_allocation_code, heap_allocated_size} =
      allocate_tuple_in_heap(
        [first_element_c_code.return_var_name, second_element_c_code.return_var_name],
        0
      )

    tuple_var = Translator.unique_helper_var()

    """
    #{first_element_c_code.code}
    #{second_element_c_code.code}
    #{heap_allocation_code}
    Dynamic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
  end

  def ast_to_c([], _context) do
    list_var = Translator.unique_helper_var()

    """
    Dynamic #{list_var} = {.type = LIST, .value.tuple = (Tuple){.start = -1, .end = -1}};
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

  def ast_to_c([{:|, _meta, [head_element, tail_assignments]}], context) do
    list_tail_in_c = Translator.honeys_ast_to_c(tail_assignments, context)
    list_header_in_c = allocate_list_header_into_heap(head_element, context)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  def ast_to_c([first_element | tail], context) do
    list_tail_in_c = Translator.honeys_ast_to_c(tail, context)
    list_header_in_c = allocate_list_header_into_heap(first_element, context)

    (list_tail_in_c.code <>
       list_header_in_c.code)
    |> gen()
    |> TranslatedCode.new(list_header_in_c.return_var_name)
  end

  # Case
  def ast_to_c({:case, _, [case_input, [do: cases]]} = _case_exp, context) do
    case_input_translated = Translator.honeys_ast_to_c(case_input, context)
    case_return_var = Translator.unique_helper_var()

    case_code =
      case_statements_to_c(
        case_input_translated.return_var_name,
        case_return_var,
        cases,
        context
      )

    """
    #{case_input_translated.code}
    Dynamic #{case_return_var};
    #{case_code}
    """
    |> gen()
    |> TranslatedCode.new(case_return_var)
  end

  # Constants
  def ast_to_c(constant, _context) when is_constant(constant) do
    case constant_to_code(constant) do
      {:ok, code} ->
        code

      _ ->
        IO.puts("We cannot convert this constant yet:")
        IO.inspect(constant)
        raise "We cannot convert this constant yet:"
    end
  end

  # Match operator, not complete
  def match_operator_to_c({:=, _, [lhs, rhs]}, context) do
    raise_exception = true
    exit_label = Translator.unique_helper_label()
    rhs_in_c = Translator.honeys_ast_to_c(rhs, context)

    pattern_matching_code = """
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
    list_element_in_c = Translator.honeys_ast_to_c(header_element, context)
    list_var = Translator.unique_helper_var()

    (list_element_in_c.code <>
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

       Dynamic #{list_var} = (Dynamic){.type = LIST, .value.tuple = (Tuple){.start = (*tuple_pool_index)-2, .end = (*tuple_pool_index)-1}};
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
       """)
    |> gen()
    |> TranslatedCode.new(list_var)
  end

  defp generate_code_for_list_head_element_assignment(
         list_head_var_name,
         assignment_head,
         exit_label
       ) do
    head_element_var_name = Translator.unique_helper_var()
    heap_index_var_name = Translator.unique_helper_var()

    """
    Dynamic #{head_element_var_name};
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
    next_list_head_var_name = Translator.unique_helper_label()
    heap_index_var_name = Translator.unique_helper_var()

    """
    Dynamic #{next_list_head_var_name};
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
    first_tuple_elm_name = Translator.unique_helper_var()
    heap_index_var_name = Translator.unique_helper_var()

    """
    Dynamic #{first_tuple_elm_name};
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
    """ <>
      pattern_matching(first_tuple_elm, first_tuple_elm_name, exit_label) <>
      get_tuple_element_from_heap(tuple_var_name, tail, index + 1, exit_label)
  end

  defp pattern_matching({:_, _meta, _} = var, _helper_var_name, _exit_label) when is_var(var),
    do: ""

  defp pattern_matching({:{}, _meta, tuple_elements}, helper_var_name, exit_label)
       when is_list(tuple_elements) do
    """
    if(#{helper_var_name}.type != TUPLE){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      get_tuple_element_from_heap(helper_var_name, tuple_elements, 0, exit_label)
  end

  defp pattern_matching({first, second}, helper_var_name, exit_label) do
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
         exit_label
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

  defp pattern_matching(list_handlers, helper_var_name, exit_label) when is_list(list_handlers) do
    """
    if(#{helper_var_name}.type != LIST){
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """ <>
      get_list_elements_from_heap(helper_var_name, list_handlers, exit_label)
  end

  defp pattern_matching(var, helper_var_name, _exit_label) when is_var(var) do
    c_var_name = var_to_string(var)

    """
    Dynamic #{c_var_name} = #{helper_var_name};
    """
  end

  defp pattern_matching(true, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 8 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(false, helper_var_name, exit_label) do
    """
    if(#{helper_var_name}.type != ATOM || #{helper_var_name}.value.string.start != 3 ) {
      op_result = (OpResult){.exception = 1, .exception_msg = "(MatchError) No match of right hand side value."};
      goto #{exit_label};
    }
    """
  end

  defp pattern_matching(nil, helper_var_name, exit_label) do
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
    string_var_name = Translator.unique_helper_var()

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
    """ <>
      generate_bitstring_checker_at_position(constant, string_var_name, 0, exit_label)
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

  defp case_statements_to_c(_case_input_var_name, _return_var_name, [], _context) do
    """
      op_result = (OpResult){.exception = 1, .exception_msg = "(CaseClauseError) no case clause matching."};
      goto CATCH;
    """
  end

  defp case_statements_to_c(
         case_input_var_name,
         return_var_name,
         [
           {:->, _meta, [[lhs_expression], case_code_block]} | further_cases
         ],
         context
       ) do
    exit_label = Translator.unique_helper_label()
    translated_case_code_block = Translator.honeys_ast_to_c(case_code_block, context)

    """
    op_result.exception = 0;
    #{pattern_matching(lhs_expression, case_input_var_name, exit_label)}
    #{exit_label}:
    if(op_result.exception == 0) {
      #{translated_case_code_block.code}
      #{return_var_name} = #{translated_case_code_block.return_var_name};
    } else {
      #{case_statements_to_c(case_input_var_name, return_var_name, further_cases, context)}
    }
    """
  end

  @doc """
  Translates constants into a Dynamic C datatype.
  Dynamic being a struct used to represent many different datatypes with the same type.
  """

  def constant_to_code(item) do
    var_name_in_c = Translator.unique_helper_var()

    cond do
      is_integer(item) ->
        {:ok,
         TranslatedCode.new(
           "Dynamic #{var_name_in_c} = {.type = INTEGER, .value.integer = #{item}};",
           var_name_in_c
         )}

      is_number(item) ->
        {:ok,
         TranslatedCode.new(
           "Dynamic #{var_name_in_c} = {.type = DOUBLE, .value.double_precision = #{item}};",
           var_name_in_c
         )}

      # Considering only strings for now
      is_bitstring(item) ->
        # TODO: Check whether the zero-termination is ok the way it is

        # TODO: consider other special chars
        # You can use `Macro.unescape_string/2` for this, but please check it
        str = String.replace(item, "\n", "\\n")
        str_len = String.length(str) + 1
        new_var_name = Translator.unique_helper_var()
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

          Dynamic #{var_name_in_c} = {.type = STRING, .value.string = (String){.start = *string_pool_index, .end = #{end_var_name}}};
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
              raise "We cannot convert arbitrary atoms such as :#{item} yet (only :true, :false and :nil)."
          end

        code = "Dynamic #{var_name_in_c} = #{value};"
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

  # Creates a situation for when all conditions are exhausted from the method below.
  def cond_statments_to_c([], cond_var_name_in_c, _context) do
    "#{cond_var_name_in_c} = (Dynamic){.type = ATOM, .value.string = (String){0, 2}};"
  end

  # Transforms conditional statements to C one condition at a time.
  def cond_statments_to_c([cond_stat | other_conds], cond_var_name_in_c, context) do
    {:->, _, [[condition] | [block]]} = cond_stat
    condition_in_c = Translator.honeys_ast_to_c(condition, context)

    block_in_c = Translator.honeys_ast_to_c(block, context)

    gen("""
    #{condition_in_c.code}
    if (to_bool(&#{condition_in_c.return_var_name})) {
      #{block_in_c.code}
      #{cond_var_name_in_c} = #{block_in_c.return_var_name};
    } else {
      #{cond_statments_to_c(other_conds, cond_var_name_in_c, context)}
    }
    """)
  end

  # Translates a block of code by calling Translator.honeys_ast_to_c for each element in that block.
  defp block_to_c({:__block__, _, exprs}, context) do
    Enum.reduce(exprs, Honey.TranslatedCode.new(), fn expr, translated_so_far ->
      translated_expr = Translator.honeys_ast_to_c(expr, context)

      %TranslatedCode{
        translated_expr
        | code: translated_so_far.code <> "\n" <> translated_expr.code
      }
    end)
  end

  # Receives existing variable names in the C code and generates the equivalent C code to a tuple containing the values of these variables
  def generate_c_tuple_from_variables(variable_names) do
    {heap_allocation_code, heap_allocated_size} = allocate_tuple_in_heap(variable_names, 0)
    tuple_var = Translator.unique_helper_var()

    """
    #{heap_allocation_code}
    Dynamic #{tuple_var} = {.type = TUPLE, .value.tuple = (Tuple){.start = (*tuple_pool_index)-#{heap_allocated_size}, .end = (*tuple_pool_index)-1}};
    """
    |> gen()
    |> TranslatedCode.new(tuple_var)
  end
end
