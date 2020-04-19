defmodule Bstk.BoardServer do
  use GenServer

  alias Bstk.{BoardRules, Board, Player, TileNew}
  @board_registry_name :board_process_registry

  def start_link(process_id) when is_integer(process_id) do
    #%{board_name: board_name, process_id: process_id, x: x, y: y}
    IO.puts("Starting BoardServer")
    GenServer.start_link(__MODULE__, process_id, name: via_tuple(process_id))
  end


  def init(process_id) do
      case :ets.lookup(:game_state, process_id) do
        [] ->
          :ignore
        [{_key, state}] ->
          send(self(), {:set_state, state})
          {:ok, state}
      end
    #"some_name", process_id, 12, 12
  end

  defp fresh_state({board_name, process_id, x, y}) do
    %{process_id: process_id,
      name: board_name,
      board: Board.new(x, y, board_name, "system_hash"),
      rules: BoardRules.new(),
      players: []
    }
  end

# registry lookup handler
defp via_tuple(process_id), do: {:via, Registry, {@board_registry_name, process_id}}


  ##########################
  ##  External Functions  ##
  ##########################


  def get_state(process_id) do
    GenServer.call(via_tuple(process_id), :get_state)
  end

  def player_joined(process_id, player_name) when is_binary(player_name), do:
    GenServer.call(via_tuple(process_id), {:add_player, player_name})


  def player_left(process_id, player_name) when is_binary(player_name), do:
    GenServer.call(via_tuple(process_id), {:remove_player, player_name})

  def token_placed(process_id, {_x, _y} = token) do
    GenServer.call(via_tuple(process_id), {:place_token, token})
  end

  def get_board(process_id), do:
    GenServer.call(via_tuple(process_id), {:get_board})


  def get_token(process_id, {x, y}), do:
    GenServer.call(via_tuple(process_id), {:get_token, {x, y}})

  ####################
  ##  Server Calls  ##
  ####################

  def handle_call({:get_board}, _from, state_data) do
    reply_success(state_data, state_data.board)
  end

  def handle_call({:get_token, {x, y}}, _from, state_data) do
    case Board.pick_tile(state_data.board, {x, y}) do
      {:ok, tile}  -> reply_success(state_data, tile)
      {:error, :no_tile_there}  -> {:reply, {:error, :no_tile_there}, state_data}
    end
  end

  def handle_call({:add_player, player_name}, _from, state_data) do
    IO.inspect("adding player #{player_name}")
    with {:ok, rules} <- BoardRules.check(state_data.rules, :user_action@add_player)
    do
      state_data
      |> add_player(player_name)
      |> update_rules(rules)
      |> reply_success(:ok)
    end
  end

  def handle_call({:remove_player, player_name}, _from, state_data) do
    with {:ok, rules} <- BoardRules.check(state_data.rules, :user_action@remove_player)
    do
      state_data
      |> remove_player(player_name)
      |> update_rules(rules)
      |> reply_success(:ok)
    end
  end

  def handle_call({:place_token, {x, y}}, _from, state_data) do
    with {:ok, rules} <- BoardRules.check(state_data.rules, :user_action@place_token)
    do
      state_data
      |> place_token({x, y})
      |> update_rules(rules)
      |> reply_success(:ok)
    end
  end

  def handle_call(:get_state, _from, state) do
    reply_success(state, state)
  end

  def handle_info({:set_state, state}, _state_data) do
    {:noreply, state}
  end


  #####################
  ####################

  defp add_player(state_data, player_name) do
    Map.replace!(state_data, :board,
    Map.replace!(state_data.board, :players,
    Map.put_new(state_data.board.players, player_name, %{player_name: player_name} )))
  end

  defp remove_player(state_data, player_name) do

    Map.replace!(state_data, :board,
    Map.replace!(state_data.board, :players,
    Map.drop(state_data.board.players, [player_name])))
  end

  defp place_token(state_data, {x, y}) do
    {:ok, new_tile} = TileNew.new(:token)
    {:ok, board} = Board.place_tile(state_data.board, new_tile, {x, y})
    Map.replace!(state_data, :board, board)
  end

  defp update_rules(state_data, rules) do
    Map.replace!(state_data, :rules, rules)
  end

  defp reply_success(%{process_id: process_id} = state_data, reply) do
    :ets.insert(:game_state, {process_id, state_data})
    {:reply, reply, state_data}
  end

end

# #def handle_call({:position_island, player, key, row, col}, _from, state_data)
#   # do
#     # board = player_board(state_data, player)
#     # with
#       # {:ok, rules} <- Rules.check(state_data.rules, {:position_islands, player}),
#       # {:ok, coordinate} <- Coordinate.new(row, col),
#       # {:ok, island} <- Island.new(key, coordinate),
#       # %{} = board <- Board.position_island(board, key, island)
#     # do
#       # state_data
#       # |> update_board(player, board)
#       # |> update_rules(rules)
#       # |> reply_success(:ok)
#     # else
#       # :error -> {:reply, :error, state_data}
#       # {:error, :invalid_coordinate} ->
#       # {:reply, {:error, :invalid_coordinate}, state_data}
#       # {:error, :invalid_island_type} ->
#       # {:reply, {:error, :invalid_island_type}, state_data}
#   # end
# # end
