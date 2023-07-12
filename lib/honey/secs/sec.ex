defmodule Honey.Sec do
  defmacro __using__(options) do
    # TODO: Check if the module name is formatted correctly: Honey.Sec.xxxx, where xxxx is the intended name for the section
    with :error <- Keyword.fetch(options, :name) do
      raise "The SEC name is required when defining a new Sec. Try 'use Honey.Sec, name: \"sec_name\"'."
    end

    exported_secs = Honey.ExportedSecs.get()
    if(!Enum.member?(exported_secs, __CALLER__.module)) do
      raise "Module #{__CALLER__.module} is defining a SEC but is not exported at honey/secs/exported_secs."
    end

    quote do
      use Honey.Translator
    end
  end
end
