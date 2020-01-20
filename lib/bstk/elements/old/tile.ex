# defmodule Bstk.Tile do
#   alias Bstk.{Coordinate, Tile}

#   @type coord :: {number, number}
#   @type tile_placement :: {boolean, coord}

#   @enforce_keys [:tile_hash, :type, :coordinates, :placement]
#   defstruct [:tile_hash, :type, :coordinates, :placement ]
#   @type tile() :: %__MODULE__{
#     tile_hash: String.t(),
#     type: String.t(),
#     coordinates: List,
#     placement: tile_placement
#   }

#   def new(tile_hash, type, placement) do
#     with [_|_] = offsets <- offsets(type),
#       %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
#     do
#       {:ok, %Tile{tile_hash: tile_hash, type: type, coordinates: coordinates, placement: placement}}
#     else
#       error -> error
#     end
#   end

#   def shift_to(%Tile{tile_hash: tile_hash, type: type, coordinates: _, placement: {placed, coord}}, upper_left) do

#     with [_|_] = offsets <- offsets(type),
#       %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
#     do
#       {:ok, %Tile{tile_hash: tile_hash, type: type, coordinates: coordinates, placement: placement}}
#     else
#       error -> error
#     end
#   end

#   def overlaps?(existing_tile, new_tile) do
#     not MapSet.disjoint?(existing_tile.coordinates, new_tile.coordinates)
#   end

#   #Private functions


#   defp offsets(:token), do: [{0, 0}]

#   defp offsets(:sticker), do: [{0, 0}, {1, 0},
#                                {0, 1}, {1, 1}]

#   defp offsets(:card), do: [{0, 0}, {1, 0}, {2, 0},
#                             {0, 1}, {1, 1}, {2, 1},
#                             {0, 2}, {1, 2}, {2, 2},
#                             {0, 3}, {1, 3}, {2, 3}] #3x4

#   defp offsets(:bigsticker), do: [{0, 0}, {1, 0}, {2, 0},
#                               {0, 1}, {1, 1}, {2, 1},
#                               {0, 2}, {1, 2}, {2, 2}] #3x3

#   defp offsets(_), do: {:error, :invalid_tile_type}

#   defp add_coordinates(offsets, upper_left) do
#     Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
#       add_coordinate(acc, upper_left, offset)
#     end)
#   end

#   defp add_coordinate(coordinates, %Coordinate{x: x, y: y},
#     {x_offset, y_offset}) do
#       case Coordinate.new(x + x_offset, y + y_offset) do
#         {:ok, coordinate}               ->
#           {:cont, MapSet.put(coordinates, coordinate)}
#         {:error, :invalid_coordinate}   ->
#           {:halt, {:error, :invalid_coordinate}}
#       end
#   end
# end
