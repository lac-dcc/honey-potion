defmodule Honey.ConstantPropagation do

  import Honey.Utils, only: [var_to_string: 1, is_var: 1]
  
  defguard is_constant(item) when
    is_number(item) or
    is_bitstring(item) or
    is_atom(item) or
    is_binary(item) or
    is_boolean(item) or
    is_nil(item)

  def run(ast) do
    Macro.postwalk(ast, [], fn segment, constants ->
      case segment do
        {:=, _meta, [lhs, rhs]} when is_constant(rhs) ->
          var_version = String.to_atom var_to_string(lhs)
          constants = Keyword.put(constants, var_version, rhs)
          {rhs, constants}

        {{:., _, [:erlang, :+]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs + rhs, constants}

        {{:., _, [:erlang, :-]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs - rhs, constants}

        {{:., _, [:erlang, :*]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs * rhs, constants}

        {{:., _, [:erlang, :/]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs / rhs, constants}

        {{:., _, [:erlang, :==]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs == rhs, constants}

        var when is_var(var) ->
          var_version = String.to_atom var_to_string(var)
          case Keyword.fetch(constants, var_version) do
            {:ok, const} ->
              {const, constants}

            :error ->
              {segment, constants}
          end

        _ ->
          {segment, constants}
      end
    end)
    |> elem(0)
  end
end
