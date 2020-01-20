defmodule Bstk.Player do
  alias Bstk.{Player}
  defstruct [:player_hash, :handle, :color]

  def new(handle, color) when is_binary(handle), do: %Player{player_hash: genhash(16), handle: handle, color: color}

  def new(handle) when is_binary(handle), do: %Player{player_hash: genhash(16), handle: handle, color: rand_color()}

  defp genhash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  defp rand_color do
      "#FFF"
  end
end
