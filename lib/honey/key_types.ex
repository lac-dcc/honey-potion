defmodule Honey.KeyType do
  def string(size) do
    %{type: :string, size: size}
  end
end
