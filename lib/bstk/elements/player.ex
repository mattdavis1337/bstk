defmodule Bstk.Player do
  alias Bstk.{Player}
  defstruct [:handle, :color]

  def new(handle, color) when is_binary(handle), do: %Player{handle: handle, color: color}

  def new(handle) when is_binary(handle), do: %Player{handle: handle, color: rand_color()}

  defp rand_color do
      "#FFF"
  end
end
