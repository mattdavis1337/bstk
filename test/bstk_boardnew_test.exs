defmodule BstkTestNew do
  use ExUnit.Case
  alias Bstk.{BoardNew, TileNew}
  doctest Bstk


  test "a board is created with 864 tile slots" do
    board = BoardNew.new(36, 24, "dumbhash")

    tile_slot = Map.get(board.tile_slots, {30, 12})
    assert tile_slot.x == 30 && tile_slot.y == 12

    tile_slot = Map.get(board.tile_slots, {35, 23})
    assert tile_slot.x == 35 && tile_slot.y == 23

    tile_slot = Map.get(board.tile_slots, {0, 0})
    assert tile_slot.x == 0 && tile_slot.y == 0

    tile_slot = Map.get(board.tile_slots, {36, 24})
    assert tile_slot == nil

    assert map_size(board.tile_slots) == 36*24
  end

  test "a board is created with 1111 tile slots" do
    board = BoardNew.new(101, 11, "dumbhash")

    tile_slot = Map.get(board.tile_slots, {30, 7})
    assert tile_slot.x == 30 && tile_slot.y == 7

    tile_slot = Map.get(board.tile_slots, {100, 10})
    assert tile_slot.x == 100 && tile_slot.y == 10

    tile_slot = Map.get(board.tile_slots, {0, 0})
    assert tile_slot.x == 0 && tile_slot.y == 0

    tile_slot = Map.get(board.tile_slots, {101, 11})
    assert tile_slot == nil

    assert map_size(board.tile_slots) == 101*11
  end

  test "a tile is created" do
    {:ok, tile} = TileNew.new(:card)
    assert tile != nil

    {msg, val} = TileNew.new(:wrong)
    assert {msg, val} == {:error, :invalid_tile_type}
  end

  test "a sticker tile is placed on a board" do
    board = BoardNew.new(36, 24, "dumbhash")
    {:ok, tile} = TileNew.new(:sticker)

    assert nil == Map.get(board.tile_slots, {4, 5}).tile_hash
    {:ok, board} = BoardNew.place_tile(board, tile, {4, 5})
    assert tile.tile_hash == Map.get(board.tile_slots, {4, 5}).tile_hash
  end

  test "tiles can not overlap" do
    board = BoardNew.new(36, 24, "dumbhash")
    {:ok, tile} = TileNew.new(:sticker)
    {:ok, tile2} = TileNew.new(:card)

    assert nil == Map.get(board.tile_slots, {4, 5}).tile_hash
    {:ok, board} = BoardNew.place_tile(board, tile, {4, 5})
    assert tile.tile_hash == Map.get(board.tile_slots, {4, 5}).tile_hash
    {:error, msg} = BoardNew.place_tile(board, tile2, {2, 2})
    assert msg == :overlapping_tile
  end

  test "tiles can't go over edge" do
    board = BoardNew.new(36, 24, "dumbhash")
    {:ok, tile} = TileNew.new(:sticker)
    {:ok, tile2} = TileNew.new(:card)

    assert nil == Map.get(board.tile_slots, {4, 5}).tile_hash
    {:ok, board} = BoardNew.place_tile(board, tile, {4, 5})
    assert tile.tile_hash == Map.get(board.tile_slots, {4, 5}).tile_hash
    {:error, msg} = BoardNew.place_tile(board, tile2, {33, 22})
    assert msg == :overlapping_tile
  end

  test "retrieve a tile at a specific coordinate" do
    board = BoardNew.new(36, 24, "dumbhash")
    {:ok, tile} = TileNew.new(:sticker)
    {:ok, tile2} = TileNew.new(:card)

    {:ok, board} = BoardNew.place_tile(board, tile, {4, 5})
    {:ok, board} = BoardNew.place_tile(board, tile2, {20, 15})

    {:ok, picked_tile} = BoardNew.pick_tile(board, {5, 6})
    assert picked_tile.tile_hash == tile.tile_hash
    {:ok, picked_tile} = BoardNew.pick_tile(board, {21, 16})
    assert picked_tile.tile_hash == tile2.tile_hash
    {:ok, picked_tile2} = BoardNew.pick_tile(board, {22, 18})
    assert picked_tile2.tile_hash == picked_tile.tile_hash
    {:error, msg} = BoardNew.pick_tile(board, {0, 1})
    assert msg == :no_tile_there
  end

  test "remove a tile at a specific coordinate and return the tile" do
    board = BoardNew.new(10, 10, "dumbhash")
    {:ok, new_tile1} = TileNew.new(:sticker)
    {:ok, new_tile2} = TileNew.new(:card)

    {:ok, board} = BoardNew.place_tile(board, new_tile1, {8, 8})
    {:ok, board} = BoardNew.place_tile(board, new_tile2, {0, 0})

    #tile1
    case BoardNew.pick_tile(board, {9, 9}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end

    {:ok, board, tile} = BoardNew.remove_tile(board, {9, 9}) #sticker
    assert tile.tile_hash == new_tile1.tile_hash

    case BoardNew.pick_tile(board, {9, 9}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end

#tile2
    case BoardNew.pick_tile(board, {0, 0}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end
    case BoardNew.pick_tile(board, {0, 1}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end
    case BoardNew.pick_tile(board, {0, 2}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end
    case BoardNew.pick_tile(board, {0, 3}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end
    case BoardNew.pick_tile(board, {2, 3}) do
      {:error, :no_tile_there} -> assert false
      {:ok, tile} -> assert true
    end

    {:ok, board, tile} = BoardNew.remove_tile(board, {0, 0}) #sticker
    assert tile.tile_hash == new_tile2.tile_hash


    case BoardNew.pick_tile(board, {0, 0}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end
    case BoardNew.pick_tile(board, {0, 1}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end
    case BoardNew.pick_tile(board, {0, 2}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end
    case BoardNew.pick_tile(board, {0, 3}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end
    case BoardNew.pick_tile(board, {2, 3}) do
      {:error, :no_tile_there} -> assert true
      {:ok, tile} -> assert false
    end
  end
end
