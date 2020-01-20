defmodule Bstk.TileNew do
  alias Bstk.{TileNew, Coord}

  @enforce_keys [:tile_hash, :type]
  defstruct [:tile_hash, :type, :placement ]
  @type t :: %__MODULE__{
    tile_hash: String.t(),
    type: String.t(),
    placement: Coord.t()
  }

  def new(type) do
    {a, b} = tile_dimensions(type)
    cond do
      a == :error ->
        {a, b}
      a != :error ->
        {:ok, %TileNew{tile_hash: genhash(16), type: type, placement: nil}}
    end
  end

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coord{x: x, y: y}, %Coord{x: offset_x, y: offset_y}) do
      # case %Coord{x + offset_x, y + offset_y} do
      #   {:ok, coordinate}               ->
      #     {:cont, MapSet.put(coordinates, coordinate)}
      #   {:error, :invalid_coordinate}   ->
      #     {:halt, {:error, :invalid_coordinate}}
      # end
  end
  #def dup(%TileNew{tile_hash: tile_hash, type: type, coordinates: _, placement: {placed, coord}}) do

  def tile_dimensions(:token), do: {1, 1}
  def tile_dimensions(:sticker), do: {2, 2}
  def tile_dimensions(:card), do: {3, 4}
  def tile_dimensions(:big_sticker), do: {3, 3}
  def tile_dimensions(_), do: {:error, :invalid_tile_type}

  defp genhash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
