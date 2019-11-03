defmodule Bstk.BoardServer do
  use GenServer

  alias Bstk.{BoardRules, Board, Player, Tile}

  def handle_info(:first, state) do
    IO.puts "This message has been handled by handle_info/2, matching on :first."
    {:noreply, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_player, %Player{} = player}, _from, state_data) do
    state_data
    |> add_player_to_state(player)
    |> reply_success
  end

  def handle_call({:remove_player, %Player{} = player}, _from, state_data) do
    state_data
    |> remove_player_from_state(player)
    |> reply_success
  end

  def handle_call({:place_tile, %Player{} = _player, %Tile{} = tile}, _from, state_data) do
    {:ok, board} = Board.position_tile(state_data[:board], tile)
    Map.replace(state_data, :board, board)
    |> reply_success

#def handle_call({:position_island, player, key, row, col}, _from, state_data)
  # do
    # board = player_board(state_data, player)
    # with
      # {:ok, rules} <- Rules.check(state_data.rules, {:position_islands, player}),
      # {:ok, coordinate} <- Coordinate.new(row, col),
      # {:ok, island} <- Island.new(key, coordinate),
      # %{} = board <- Board.position_island(board, key, island)
    # do
      # state_data
      # |> update_board(player, board)
      # |> update_rules(rules)
      # |> reply_success(:ok)
    # else
      # :error -> {:reply, :error, state_data}
      # {:error, :invalid_coordinate} ->
      # {:reply, {:error, :invalid_coordinate}, state_data}
      # {:error, :invalid_island_type} ->
      # {:reply, {:error, :invalid_island_type}, state_data}
  # end
# end


  end

  defp add_player_to_state(state_data, player) do
    put_in(state_data.players, Map.put_new(state_data.players, player.handle, player))
  end

  defp remove_player_from_state(state_data, player), do:
    put_in(state_data.players, Map.delete(state_data.players, player.handle))

  defp reply_success(state_data), do: {:reply, state_data, state_data}

    #Map.replace(state_data, :players, List.insert_at(state_data.players, 0, %{player_name: name}))


  # def handle_call({:add_player, name}, _from, state_data) do
  #   with {:ok, rules} <- Rules.check(state_data.rules, :add_player)
  #   do
  #     state_data
  #       |> add_player(name)
  #       |> update_rules(rules)
  #       |> reply_success(:ok)
  #   else
  #     :error -> {:reply, :error, state_data}
  #   end
  # end


  def handle_cast({:demo_cast, new_value}, state) do
    {:noreply, Map.put(state, :test, new_value)}
  end




  #defp update_rules(state_data, rules), do: %{state_data | rules: rules}




  def init(board_name) do
    {:ok, %{board: Board.new(board_name), players: Map.new(), rules: %BoardRules{}}}
  end

#Public Interface
  def demo_cast(pid, new_value) do
    GenServer.cast(pid, {:demo_cast, new_value})
  end

  def place_tile(pid, player, tile) do
    GenServer.call(pid, {:place_tile, player, tile})
  end

  def remove_player(pid, player) do
    GenServer.call(pid, {:remove_player, player})
  end

  def add_player(pid, player) do
    GenServer.call(pid, {:add_player, player})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def start_link(board_name) when is_binary(board_name) do
    GenServer.start_link(__MODULE__, board_name, name: :BstkGame)
  end

end
