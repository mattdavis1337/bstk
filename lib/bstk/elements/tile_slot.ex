defmodule Bstk.TileSlot do
  alias __MODULE__
  alias Bstk.{TileSlot, TileNew}

  @enforce_keys [:x, :y]
  defstruct [:x, :y, :tile_hash, :tile_slot_hash]

  def new(x, y), do:
    {:ok, %TileSlot{x: x, y: y, tile_hash: nil, tile_slot_hash: genhash(24)}}

  def place_tile(tile_slot, %TileNew{} = tile) do
    %TileSlot{tile_slot | tile_hash: tile.tile_hash}
  end

  def clear_tile(tile_slot) do
    %TileSlot{tile_slot | tile_hash: nil}
  end

  defp genhash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
