defmodule Honey.Utils do
  def compile_error!(env, description) do
    raise CompileError, line: env.line, file: env.file, description: description
  end
end
