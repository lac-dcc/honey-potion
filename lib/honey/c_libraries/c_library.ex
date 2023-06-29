defmodule Honey.CLibrary do
  defmacro __using__(_opts) do
    exported_c_libraries = Honey.ExportedCLibraries.get()
    if(!Enum.member?(exported_c_libraries, __CALLER__.module)) do
      raise "Module #{__CALLER__.module} is defining a C library but is not exported at honey/c_libraries/exported_c_libraries."
    end

    quote do
    end
  end
end
