defmodule Honey.Sec do
  defmacro __using__(options) do
    with :error <- Keyword.fetch(options, :name) do
      raise """
      The SEC name is required when defining a new Sec. Try:
      use Honey.Sec,
        name: "sec_name",
        c_ctx_arg_type: "type"
      """
    end

    with :error <- Keyword.fetch(options, :c_ctx_arg_type) do
      raise """
      The argument type is required when defining a new Sec. Try:
      use Honey.Sec,
        name: "sec_name",
        c_ctx_arg_type: "type"
      """
    end

    exported_secs = Honey.ExportedSecs.get()

    if(!Enum.member?(exported_secs, __CALLER__.module)) do
      raise "Module #{__CALLER__.module} is defining a SEC but is not exported at honey/secs/exported_secs."
    end

    quote do
      use Honey.Translator

      Module.register_attribute(__MODULE__, :name, persist: true)
      @name unquote(options[:name])

      Module.register_attribute(__MODULE__, :c_ctx_arg_type, persist: true)
      @c_ctx_arg_type unquote(options[:c_ctx_arg_type] || [])

      Module.register_attribute(__MODULE__, :c_includes, persist: true)
      @c_includes unquote(options[:c_includes] || [])

      Module.register_attribute(__MODULE__, :c_structs, persist: true)
      @c_structs unquote(options[:c_structs] || [])
    end
  end
end
