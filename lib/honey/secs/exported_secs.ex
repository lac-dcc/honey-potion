defmodule Honey.ExportedSecs do
  def get() do
    [
      Honey.Sec.Xdp,
      Honey.Sec.Sys_enter,
      Honey.Sec.Sys_enter_write,
      Honey.Sec.Sys_enter_kill
    ]
  end

  def get_from_sec_name!(sec_name) do
    module =
      get()
      |> Enum.find(nil, fn module ->
        sec_name == Enum.at(module.__info__(:attributes)[:name], 0)
      end)

    if(!module) do
      raise "The SEC '#{sec_name}' is not supported by Honey at the moment."
    end

    module
  end

  def check!() do
    get()
    |> Enum.reduce([], fn module, sec_names ->
      case Code.ensure_loaded(module) do
        {:module, _} ->
          nil

        {:error, :nofile} ->
          raise "Module #{module} is being exported in secs/exported_secs, but it does not exist."

        x ->
          raise "Module #{module} is being exported in secs/exported_secs, but Honey cannot load it: #{x}"
      end

      sec_name = Enum.at(module.__info__(:attributes)[:name], 0)

      if(Enum.find(sec_names, nil, &(&1 == sec_name))) do
        repeated_module = get_from_sec_name!(sec_name)
        raise "SEC Modules #{module} and #{repeated_module} implements the same SEC name: '#{sec_name}'."
      end

      [sec_name | sec_names]
    end)
  end
end
