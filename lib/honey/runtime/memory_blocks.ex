defmodule Honey.Runtime.MemoryBlocks do
  def create(size) do
      [{0, size}]
  end

  def get(memory, size) do
    {memory, position} = Enum.reduce(memory, {[], -1}, fn block, {acc, pos} ->
      if pos == -1 do
        {pos_b, size_b} = block
        cond do
          size_b > size ->
            {[{pos_b + size, size_b - size} | acc], pos_b}
          size_b == size ->
            {acc, pos_b}
          true ->
            {[{pos_b, size_b} | acc], pos}
        end
      else
        {[block | acc], pos}
      end
    end)
    memory = Enum.reverse(memory)
    {memory, position}
  end

  def give(memory, position, size) do
    # Accumulator keeps last element seen and state
    # State = 0 -> uninserted
    # State = 1 -> uninserted, seeking concatenation with the next one, but valid
    # State = 2 -> Done
    {memory, last, state} =
    Enum.reduce(memory, {[], {0, -1}, 0}, fn {pos_b, size_b}, {acc, prev, state} ->
      cond do 
        state == 2 ->
          {[{pos_b, size_b} | acc], {pos_b, size_b}, 2}
        state == 1 ->
          {pos_prev, size_prev} = prev
          if pos_prev + size_prev == pos_b do
            {[{pos_prev, size_prev + size_b} | acc], {pos_prev, size_prev + size_b}, 2}
          else
            {[{pos_b, size_b} | [prev | acc]], {pos_b, size_b}, 2}
          end
        pos_b + size_b == position ->
          {acc, {pos_b, size_b + size}, 1}
        position + size == pos_b ->
          {[{position, size + size_b} | acc], {position, size + size_b}, 2}
        elem(prev, 0) + elem(prev, 1) < position && position + size < pos_b ->
          {[{pos_b, size_b} | [{position, size} | acc]], {pos_b, size_b}, 2}
        true ->
          {[{pos_b, size_b} | acc], {pos_b, size_b}, 0}
      end
    end)
    memory = case state do
      0 -> [{position, size} | memory]
      1 -> [last | memory]
      2 -> memory
    end
    Enum.reverse(memory)
  end
end
