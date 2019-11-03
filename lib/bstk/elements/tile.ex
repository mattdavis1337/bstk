defmodule Bstk.Tile do
  alias Bstk.{Coordinate, Tile}
  @enforce_keys [:tile_hash, :type, :coordinates, :glow_level, :flipped]
  defstruct [:tile_hash, :type, :coordinates, :glow_level, :flipped]

  #@glow_range 0..10

  def new(tile_hash, type, %Coordinate{} = upper_left) do
    with [_|_] = offsets <- offsets(type),
      %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
    do
      {:ok, %Tile{tile_hash: tile_hash, type: type, coordinates: coordinates, glow_level: 0, flipped: false}}
    else
      error -> error
    end
  end

  # def new(type, color, value, description, creator) do
  #   with [_|_] = offsets <- offsets(type)

  # end

  #Public functions
  def flip(tile) do
    {:ok, %Tile{ tile | flipped: !tile.flipped}}
  end


  def shift_to(%Tile{tile_hash: tile_hash, type: type, coordinates: _, glow_level: glow_level, flipped: flipped}, upper_left) do
    with [_|_] = offsets <- offsets(type),
      %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
    do
      {:ok, %Tile{tile_hash: tile_hash, type: type, coordinates: coordinates, glow_level: glow_level, flipped: flipped}}
    else
      error -> error
    end
  end

  def overlaps?(existing_tile, new_tile) do
    not MapSet.disjoint?(existing_tile.coordinates, new_tile.coordinates)
  end



  #Private functions


  defp offsets(:token), do: [{0, 0}]

  defp offsets(:sticker), do: [{0, 0}, {1, 0},
                               {0, 1}, {1, 1}]

  defp offsets(:card), do: [{0, 0}, {1, 0}, {2, 0},
                            {0, 1}, {1, 1}, {2, 1},
                            {0, 2}, {1, 2}, {2, 2},
                            {0, 3}, {1, 3}, {2, 3}] #3x4

  defp offsets(:bigsticker), do: [{0, 0}, {1, 0}, {2, 0},
                              {0, 1}, {1, 1}, {2, 1},
                              {0, 2}, {1, 2}, {2, 2}] #3x3

  defp offsets(_), do: {:error, :invalid_tile_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{x: x, y: y},
    {x_offset, y_offset}) do
      case Coordinate.new(x + x_offset, y + y_offset) do
        {:ok, coordinate}               ->
          {:cont, MapSet.put(coordinates, coordinate)}
        {:error, :invalid_coordinate}   ->
          {:halt, {:error, :invalid_coordinate}}
      end
  end
end
