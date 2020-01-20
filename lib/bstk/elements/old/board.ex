# defmodule Bstk.Board do
#   alias Bstk.{Board, Tile}
#   defstruct [:board_name, :tiles]

#   def new(), do: %Board{board_name: genhash(16), tiles: %{}}

#   def new(board_name), do: %Board{board_name: board_name, tiles: %{}}


#   #Public functions

#   def position_tile(board, %Tile{} = tile) do
#     case overlaps_existing_tile?(board, tile) do
#       true -> {:error, :overlapping_tile}
#       false -> {:ok, Map.put(board, :tiles, Map.put(board.tiles, tile.tile_hash, tile))}
#     end
#   end

#   def valid_layout?(board) do
#     Enum.count(board.tiles) > 0
#   end

#   def reposition_tile(board, tile_hash, new_upper_left) do
#     {:ok, tile}  = Tile.shift_to(get_tile(board, tile_hash), new_upper_left)
#     position_tile(board, tile)
#   end

#   def flip_tile(board, tile_hash) do
#     {:ok, tile}  = Tile.flip(get_tile(board, tile_hash))
#     Map.put(board, :tiles, Map.put(board.tiles, tile_hash, tile))
#   end

#   def claim_tile(board, tile_hash, _user_hash) do
#     _tile = get_tile(board.tiles, tile_hash)
#   end

#   def get_tile(board, tile_hash) do
#     Map.get(board.tiles, tile_hash)
#   end

#   #Private functions

#   defp genhash(length) do
#     :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
#   end

#   defp overlaps_existing_tile?(board, new_tile) do
#     Enum.any?(board.tiles, fn {_tile_hash, tile} ->
#       Tile.overlaps?(tile, new_tile)
#     end)
#   end



#   #def overlaps_with_existing?(board, tile) do
#     #  not MapSet.disjoint?(existing_tile.coordinates, new_tile.coordinates)
#   #end


# end
