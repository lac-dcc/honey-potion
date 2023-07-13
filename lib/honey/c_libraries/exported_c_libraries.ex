defmodule Honey.ExportedCLibraries do
  def get() do
    [
      Honey.Bpf_helpers,
      Honey.Parse
    ]
  end

  def check!() do
    # TODO: Verify if the modules in get() are valid:
    # - It exists
    # - It implements the right functions
    # - Its sec name is unique

    get()
    |> Enum.each(fn module ->
      case Code.ensure_loaded(module) do
        {:module, _} ->
          nil

        {:error, :nofile} ->
          raise "Module #{module} is being exported in c_libraries/exported_c_libraries, but it does not exist."

        x ->
          raise "Module #{module} is being exported in c_libraries/exported_c_libraries, but Honey cannot load it: #{x}"
      end
    end)
  end
end
