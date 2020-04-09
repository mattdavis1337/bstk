defmodule Bstk.Board do
  alias Bstk.{Board, TileNew, TileSlot}
  defstruct [:board_name, :width, :height, :tile_slots, :tiles, :creator_hash, :players]

  def new(x, y, board_name, creator_hash), do:
    %Board{board_name: board_name,
              width: x,
              height: y,
              tile_slots: map_tile_slots(offset_coords(x, y)),
              tiles: %{},
              creator_hash: creator_hash,
              players: %{}}


  def place_tile(board, %TileNew{} = new_tile, {x, y}) do
    case overlaps_existing_tile?(board, new_tile, {x, y}) do
      true -> {:error, :overlapping_tile}
      false ->
        {:ok, add_tile_to_board(board, new_tile, {x, y})}
    end
  end

  def pick_tile(board, {x, y}) do
    tile_slot = Map.get(board.tile_slots, {x, y})
    if tile_slot != nil do
      tile = Map.get(board.tiles, tile_slot.tile_hash)
      if tile != nil do
        {:ok, tile}
      else
          {:error, :no_tile_there}
      end
    else
      {:error, :no_tile_there}
    end
  end

  def remove_tile(board, {x, y}) do
    case pick_tile(board, {x, y}) do
      {:ok, tile} -> remove_tile_from_board(board, tile, {x, y})
      {:error, :no_tile_there} -> {:error, :no_tile_there}
    end
  end

  #defp populate_board(_board, _layout) do

    #{:ok, board} = Board.place_tile(board, tile, {4, 5})

    #Enum.each(1..(board.x), fn x -> Enum.each(1..(board.y), fn y -> place_tile(board, TileNew.new(:token), {x, y} )))


    #place_tile(board, )

    # def tile_dimensions(:token), do: {1, 1}
    # def tile_dimensions(:sticker), do: {2, 2}
    # def tile_dimensions(:card), do: {3, 4}
    # def tile_dimensions(:big_sticker), do: {3, 3}
  #end

  defp add_tile_to_board(board, new_tile, {x, y}) do
    tile_slots = TileNew.tile_dimensions(new_tile.type)
        |> offset_coords()
        |> shift_offset_coords({x, y})
        |> Enum.map(fn coord -> {coord, TileSlot.place_tile(Map.get(board.tile_slots, coord), new_tile)} end)
        |> Enum.reduce(board.tile_slots, fn {key, val}, acc -> Map.put(acc, key, val) end)

    Map.put(board, :tiles, Map.put(board.tiles, new_tile.tile_hash, new_tile))
    |> Map.put(:tile_slots, tile_slots)
  end

  defp remove_tile_from_board(board, tile, {x, y}) do

    #clear the tile_slots that had tile in it
    result = get_adjacent_occupied_slots(board, tile.tile_hash, {x, y}, [])
    |> Enum.map(fn tile_slot -> {{tile_slot.x, tile_slot.y}, TileSlot.clear_tile(tile_slot)} end)
    |> Enum.reduce(board.tile_slots, fn {key, val}, acc -> Map.put(acc, key, val) end)

    #remove tile from tile list
    {tile, tile_map} = Map.pop(board.tiles, tile.tile_hash)

    {:ok, Map.put(board, :tiles, tile_map)
    |> Map.put(:tile_slots, result), tile}

  end

  defp get_adjacent_occupied_slots(board, tile_hash, {x, y}, acc, r \\ 0) do
    #radial pulse algorithm
    slots_that_match = get_adjacent_slots(board, {x, y}, r)
    |> Enum.reject(&(&1 == nil))
    |> check_slots_for_tile(tile_hash)
    if (Kernel.length(slots_that_match) > 0), do: get_adjacent_occupied_slots(board, tile_hash, {x,y}, slots_that_match ++ acc, r+1), else: acc
  end

  defp check_slots_for_tile(slots, tile_hash) do
    #if x a tile_slot that matches tile_hash, put it in the accumulator. Otherwise do not add it.
    Enum.reduce(slots, [], fn cur_slot, acc -> if (cur_slot.tile_hash == tile_hash), do: [cur_slot | acc], else: acc end)
  end


  defp get_adjacent_slots(board, {x, y}, r) when r >= 1 do
    [Map.get(board.tile_slots, {x-r, y-r}) |
    [Map.get(board.tile_slots, {x, y-r}) |
    [Map.get(board.tile_slots, {x+r, y-r}) |
    [Map.get(board.tile_slots, {x-r, y}) |
    [Map.get(board.tile_slots, {x+r, y}) |
    [Map.get(board.tile_slots, {x-r, y+r}) |
    [Map.get(board.tile_slots, {x, y+r}) |
    [Map.get(board.tile_slots, {x+r, y+r}) |
    [] ] ] ] ] ] ] ] ]
  end

  defp get_adjacent_slots(board, {x, y}, _r) do
    [Map.get(board.tile_slots, {x, y})]
  end

  defp overlaps_existing_tile?(board, new_tile, origin) do
    TileNew.tile_dimensions(new_tile.type)
    |> offset_coords()
    |> shift_offset_coords(origin)
    |> Enum.any?(fn coord -> tile_slot = Map.get(board.tile_slots, coord); tile_slot == nil || tile_slot.tile_hash != nil
    end)
  end

  defp genhash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  defp shift_offset_coords(coords, {x, y}), do: shift_offset_coords(coords, x, y)

  #with a list of coords {a, b} adds x to all a in coords and y to all b in coords
  defp shift_offset_coords(coords, x, y) do
    Enum.map(coords, fn {x1, y1} -> {x1 + x, y1 + y} end)
  end

  defp offset_coords({x, y}) do
    offset_coords(x, y)
  end

  #returns a list of {a, b} tuples that represent squares in a grid x wide and y tall
  defp offset_coords(x, y) do
    Enum.reduce(0..((x*y)-1), [], fn val, acc ->
      new_x = rem(val, x);
      new_y = div(val, x);
      [{new_x, new_y} | acc];
    end)
  end

  defp map_tile_slots(coords) do
    Enum.reduce(coords, Map.new(), fn val, acc ->
      {x, y} = val
      {:ok, tile_slot} = TileSlot.new(x, y);
      Map.put(acc, val, tile_slot)
    end)
  end
end
