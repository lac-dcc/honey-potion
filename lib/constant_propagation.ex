defmodule Honey.ConstantPropagation do
  def is_constant(item) do
    is_number(item) or is_bitstring(item) or is_atom(item) or is_binary(item) or is_boolean(item) or
      is_nil(item)
  end

  def run(ast) do
    # {_version, _kind, _metadata, [clause | _other_clauses]} = fun_def
    # {_metadata, _arguments, _guards, ast} = clause

    # IO.puts("======== Printing using Macro.postwalk\n")

    {new_ast, _constants} =
      Macro.postwalk(ast, Keyword.new(), fn segment, constants ->
        # IO.inspect(segment)
        {new_segment, constants} =
          case segment do
            {:=, _meta, [lhs, rhs]} ->
              if(is_constant(rhs)) do
                {var_name, meta, context} = lhs

                var_version =
                  String.to_atom(
                    Atom.to_string(var_name) <> to_string(meta[:version]) <> to_string(context)
                  )

                constants = Keyword.put(constants, var_version, rhs)
                {rhs, constants}
              else
                {segment, constants}
              end

              {{:., _, [:erlang, :+]}, _, [lhs, rhs]} ->
              if(is_constant(lhs) and is_constant(rhs)) do
                {lhs + rhs, constants}
              else
                {segment, constants}
              end

              {{:., _, [:erlang, :-]}, _, [lhs, rhs]} ->
              if(is_constant(lhs) and is_constant(rhs)) do
                {lhs - rhs, constants}
              else
                {segment, constants}
              end

              {{:., _, [:erlang, :*]}, _, [lhs, rhs]} ->
              if(is_constant(lhs) and is_constant(rhs)) do
                {lhs * rhs, constants}
              else
                {segment, constants}
              end

              {{:., _, [:erlang, :/]}, _, [lhs, rhs]} ->
              if(is_constant(lhs) and is_constant(rhs)) do
                {lhs / rhs, constants}
              else
                {segment, constants}
              end

              {{:., _, [:erlang, :==]}, _, [lhs, rhs]} ->
              if(is_constant(lhs) and is_constant(rhs)) do
                {lhs == rhs, constants}
              else
                {segment, constants}
              end

            {var_name, meta, context} ->
              if(is_atom(var_name) and is_atom(context)) do
                var_version =
                  String.to_atom(
                    Atom.to_string(var_name) <> to_string(meta[:version]) <> to_string(context)
                  )

                case Keyword.fetch(constants, var_version) do
                  {:ok, const} ->
                    {const, constants}

                  :error ->
                    {segment, constants}
                end
              else
                {segment, constants}
              end

            _ ->
              {segment, constants}
          end

        # IO.write("    AST: ")
        # IO.inspect(new_segment)

        {new_segment, constants}
      end)

    # IO.puts("\n =======New AST after Constant propagation:")
    # IO.inspect(new_ast)

    new_ast
  end
end
