defmodule BstkServerTest do
   use ExUnit.Case
   alias Bstk.{BoardServer, BoardSupervisor}

  #@tag :pending
  test "Server starts as expected" do
    {:ok, game} = BoardServer.start_link(1)
    #%{board_name: "mainboard", process_id: 1, x: 10, y: 10}
    assert game
  end


  test "Player add and remove test" do
    {:ok, _game} = BoardServer.start_link(1)

    board = BoardServer.get_board(1)

    assert Map.has_key?(board.players, "Matt") == false

    BoardServer.player_joined(1, "Matt")

    board = BoardServer.get_board(1)

    assert Map.has_key?(board.players, "Matt") == true

    BoardServer.player_left(1, "Matt")

    board = BoardServer.get_board(1)

    assert Map.has_key?(board.players, "Matt") == false
  end

  test "Create board" do
    {:ok, _game} = BoardServer.start_link(1)

    board = BoardServer.get_board(1)
    assert board.board_name == "main_gameboard"
  end

  test "Create multiple boards" do
    {:ok, _game} = BoardServer.start_link(1)
    {:ok, _game} = BoardServer.start_link(2)
    :ignore = BoardServer.start_link(3)

    mainboard = BoardServer.get_board(1)
    subboard = BoardServer.get_board(2)
    assert mainboard.board_name == "main_gameboard"
    assert subboard.board_name == "sub_board"
  end

  test "Create board and add tiles" do
    {:ok, _game} = BoardServer.start_link(1)

    BoardServer.token_placed(1, {0, 0})
    BoardServer.token_placed(1, {0, 1})
    BoardServer.token_placed(1, {0, 2})

    _board = BoardServer.get_board(1)

    token = BoardServer.get_token(1, {0, 0})
    token2 = BoardServer.get_token(1, {0, 1})
    token3 = BoardServer.get_token(1, {0, 2})
    {:error, msg} = BoardServer.get_token(1, {0, 3})

    assert token.type == :token
    assert token2.type == :token
    assert token3.type == :token
    assert msg == :no_tile_there
  end
end



#   test "BoardServer starts correctly" do
#     {:ok, board_server} = BoardServer.start_link("Board1")

#     board_server_state = :sys.get_state(board_server)
#     assert board_server_state.board.board_name == "Board1"

#     board_server_state = BoardServer.get_state(board_server)
#     assert board_server_state.board.board_name == "Board1"
#   end

#   test "can add players" do
#     {:ok, board_server} = BoardServer.start_link("Board1")
#     state = BoardServer.add_player(board_server, Player.new("Matt"))

#     board_server_state = :sys.get_state(board_server)

#     assert state == board_server_state

#     #IO.inspect(board_server_state)

#     assert Kernel.length(Map.keys(board_server_state.players)) == 1

#     state = BoardServer.add_player(board_server, Player.new("Stephanie"))
#     assert Kernel.length(Map.keys(state.players)) == 2
#     #Enum.contaboard_server_state.
#   end

#   test "can remove players" do
#     {:ok, board_server} = BoardServer.start_link("Board1")
#     state = BoardServer.add_player(board_server, Player.new("Matt"))

#     assert Kernel.length(Map.keys(state.players)) == 1

#     state = BoardServer.remove_player(board_server, %Player{handle: "Matt"})

#     assert Kernel.length(Map.keys(state.players)) == 0
#   end

#   test "can position a tile" do
#     {:ok, board_server} = BoardServer.start_link("Board1")
#     state = BoardServer.add_player(board_server, Player.new("Matt"))
#     {:ok, coord} = Coordinate.new(0, 0)
#     {:ok, tile} = Tile.new(:sticker1, :sticker, coord)
#     state = BoardServer.place_tile(board_server, %Player{handle: "Matt"}, tile)
#     assert Kernel.length(Map.keys(state.board.tiles)) == 1
#   end
