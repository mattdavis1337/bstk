# defmodule BstkServerTest do
#   use ExUnit.Case
#   alias Bstk.{BoardServer, Player, Tile, Coordinate}

#   #@tag :pending
#   # test "Server starts as expected" do
#   #   {:ok, game} = Game.start_link("Frank")
#   #   assert game
#   # end

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

# end
