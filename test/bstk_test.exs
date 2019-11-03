defmodule BstkTest do
  use ExUnit.Case
  alias Bstk.{Board, Coordinate, Tile}
  doctest Bstk

  #@tag :pending
  defp setup_board do
    {:ok, c1} = Coordinate.new(0,0)
    {:ok, c2} = Coordinate.new(0,3)

    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    {:ok, t2} = Tile.new(:tile_hash2, :bigsticker, c2)

    board = Board.new()
    {:ok, board} = Board.position_tile(board, t1)
    {:ok, board} = Board.position_tile(board, t2)
    board
  end

  defp setup_board_plus do
    {:ok, c1} = Coordinate.new(0,0)
    {:ok, c2} = Coordinate.new(0,3)

    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    {:ok, t2} = Tile.new(:tile_hash2, :bigsticker, c2)

    board = Board.new()

    {:ok, board} = Board.position_tile(board, t1)
    {:ok, board} = Board.position_tile(board, t2)

    %{b: board, t1: t1, t2: t2, c1: c1, c2: c2}
  end

  test "creates a coordinate" do
    {:ok, c1} = Coordinate.new(0,3)
    assert c1 != nil
  end

  test "creates a tile" do
    {:ok, c1} = Coordinate.new(0,3)
    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    assert t1 != nil
  end

  test "creates a board" do
    assert Board.new != nil
  end

  test "does not allow overlapping tiles" do
    {:ok, c1} = Coordinate.new(0,1)
    {:ok, c2} = Coordinate.new(0,0)

    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    {:ok, t2} = Tile.new(:tile_hash2, :bigsticker, c2)

    board = Board.new()

    {:ok, board} = Board.position_tile(board, t1)
    {:error, msg} = Board.position_tile(board, t2)
    assert msg == :overlapping_tile
  end

  test "allows nonoverlapping tiles" do
    {:ok, c1} = Coordinate.new(0,0)
    {:ok, c2} = Coordinate.new(0,3)

    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    {:ok, t2} = Tile.new(:tile_hash2, :bigsticker, c2)

    board = Board.new()

    with {:ok, board} = Board.position_tile(board, t1),
         {:ok, board} = Board.position_tile(board, t2)
         do
           assert board != nil
        #  else
        #    :error ->
        #      assert false
    end
  end

  test "allows tiles to move to open spots" do
    board = setup_board()
    {:ok, c3} = Coordinate.new(0,8)
    {:ok, board} = Board.reposition_tile(board, :tile_hash1, c3)
    assert board
  end

  test "does not allow tiles to move to closed spots" do
    board = setup_board()
    {:ok, c3} = Coordinate.new(0,2)
    {:error, msg} = Board.reposition_tile(board, :tile_hash1, c3)
    assert msg == :overlapping_tile
  end

  test "valid board when one tile" do
    {:ok, c1} = Coordinate.new(0,0)
    {:ok, c2} = Coordinate.new(0,3)

    {:ok, t1} = Tile.new(:tile_hash1, :bigsticker, c1)
    {:ok, _t2} = Tile.new(:tile_hash2, :bigsticker, c2)

    board = Board.new()

    refute Board.valid_layout?(board)

    {:ok, board} = Board.position_tile(board, t1)

    assert Board.valid_layout?(board)
  end

  test "flips a tile" do
    %{b: board, t1: t1, t2: _t2} = setup_board_plus()
    flip_val = t1.flipped

    #flip me once
    board = Board.flip_tile(board, t1.tile_hash)
    tile_chk = Board.get_tile(board, t1.tile_hash)

    assert tile_chk.flipped == !flip_val

    #flip me twice
    board = Board.flip_tile(board, t1.tile_hash)
    tile_chk = Board.get_tile(board, t1.tile_hash)

    assert tile_chk.flipped == flip_val

    #flip me once again
    board = Board.flip_tile(board, t1.tile_hash)
    tile_chk = Board.get_tile(board, t1.tile_hash)

    assert tile_chk.flipped == !flip_val
  end

  test "a tile is claimed by a user" do

    %{b: _board, t1: _t1, t2: _t2} = setup_board_plus()
    #board = Board.claim_tile(board, t1.tile_hash, user.hash)

    #assert false
  end

end
