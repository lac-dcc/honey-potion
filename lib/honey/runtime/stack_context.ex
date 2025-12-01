defmodule Honey.Runtime.StackContext do
  alias Honey.TypeSet
  alias Honey.Runtime.MemoryBlocks
  alias Honey.Runtime.TranslatorContext
  @doc """
  Gets a Translated_Code's variable value representation in the stack by pointer dereferencing.
  """
  def get_code_value(translated_code, context) do
    #IO.inspect("Searching in")
    #IO.inspect(translated_code)
    #IO.inspect(Map.get(translated_code.context.var_pointer_map, translated_code.return_var_name))

    elem = Map.get(context.var_pointer_map, translated_code.return_var_name)
    c_var_position = case elem do 
      {pos, _} -> pos
      {pos, _, _} -> pos 
      nil -> {:custom, translated_code.return_var_name}
    end

    cond do 
      match?({:custom, _name}, c_var_position) -> 
        {_, name} = c_var_position
        name
      TypeSet.is_generic?(translated_code.return_var_type) ->
        "(*(Generic*) (stack + #{c_var_position}))"
      TypeSet.is_integer?(translated_code.return_var_type) ->
        "(*(int*) (stack + #{c_var_position}))"
      TypeSet.is_string?(translated_code.return_var_type) ->
        "(*(String*) (stack + #{c_var_position}))"
      TypeSet.is_void?(translated_code.return_var_type) ->
        "(*(void**) ((stack + #{c_var_position})))"
      #"(*(String*) (stack + #{c_var_position}))"
      true ->
      # TODO: This should handle CTX variables somehow. Currently (?) they get a type of :type_ctx_pid.
        "(*(Generic*) (stack + #{c_var_position}))"
    end
  end

  def get_var_pos(context, var_name) do
    elem = Map.get(context.var_pointer_map, var_name)
    case elem do 
      {pos, _} -> pos
      {pos, _, _} -> pos 
    end
  end

  def defragment_context(context) do
    %TranslatorContext{free_memory_blocks: memory, var_pointer_map: var_map, pos_to_var_map: pos_map} = context
    positions = Enum.sort(Map.keys(pos_map))
    {defrag_code, var_map, pos_map, _target_pos} = Enum.reduce(positions, {"//Starting Defragmentation \n", var_map, pos_map, 0}, fn old_pos, {defrag_code, var_map, pos_map, target_pos} ->
      {name, size} = Map.get(pos_map, old_pos)

      if(target_pos == old_pos) do
        {"", var_map, pos_map, target_pos + size}
      else
        var_map = Map.update!(var_map, name, fn {_pos, size} ->
          {target_pos, size}
        end)
        pos_map = Map.drop(pos_map, [old_pos])
        pos_map = Map.put(pos_map, target_pos, {name, size})

        defrag_code = defrag_code <>
          case size do
          4 ->
            """
            stack_int = (int*) (stack + #{target_pos});
            stack_int[0] = *((int*) (stack + #{old_pos}));
            """
          8 ->
            """
            stack_str = (String*) (stack + #{target_pos});
            stack_str[0] = *((String*) (stack + #{old_pos}));
            """
          12 ->
            """
            stack_gen = (Generic*) (stack + #{target_pos});
            stack_gen[0] = *((Generic*) (stack + #{old_pos}));
            """
        end

        target_pos = target_pos + size
        {defrag_code, var_map, pos_map, target_pos}
      end
    end)
    memory = MemoryBlocks.defrag(memory)
    context = %{context |
      var_pointer_map: var_map,
      pos_to_var_map: pos_map,
      free_memory_blocks: memory
    }
    {context, defrag_code}
  end

  def allocate_var(context, var_name_in_c, size) do
      {memory, pos} = MemoryBlocks.get(context.free_memory_blocks, size)
      {memory, defrag_code, pos} = 
        if pos == -1 do
          {context, defrag_code} = defragment_context(context)
          {memory, pos} = MemoryBlocks.get(context.free_memory_blocks, size)
          if pos == -1 do
            raise "Not enough stack size."
          end
          {memory, defrag_code, pos}
        else
          {memory, "", pos} 
        end
      context = %{ context | 
        free_memory_blocks: memory,
        var_pointer_map: Map.put(context.var_pointer_map, var_name_in_c, {pos, size}),
        pos_to_var_map: Map.put(context.pos_to_var_map, pos, {var_name_in_c, size})
      }
      {context, defrag_code}
  end

  def return_var(context, var_name_in_c, keep \\ true) do
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
          var_pointer_map: pointer_map,
          pos_to_var_map: Map.drop(context.pos_to_var_map, [pos])
        }
      {_, _, :dead} -> 
        %{ context | 
          var_pointer_map: pointer_map 
        }
    end
  end

  def deallocate_code(context, translated_code) do
    var_name_in_c = translated_code.return_var_name
    #IO.inspect("Removing")
    #IO.inspect(var_name_in_c)
    if String.match?(var_name_in_c, ~r/^helper_var_/) do
      #IO.inspect("Helper")
      return_var(context, var_name_in_c)
      #else
      #dv = Keyword.get(meta, :dv)
      #if MapSet.member?(dv, String.to_atom(var_name_in_c)) do
      #  IO.inspect("Dead")
      #  return_var_in_context(context, var_name_in_c)
      else
        if context.free_program_var do
        #IO.inspect("Freeprogvar")
        #IO.inspect(return_var(context, var_name_in_c))
            return_var(context,var_name_in_c)
        else
          context
#        case Keyword.get(meta, :last) do
#          true -> IO.inspect("Last")
#            IO.inspect(meta)
#            return_var_in_context(context, var_name_in_c)
#          _ -> context
        #end
      end
    end
  end

end
