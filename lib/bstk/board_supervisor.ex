defmodule Bstk.BoardSupervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic `Bstk.Board` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.
  These processes will spawn for each `board_id` provided to the
  `Bstk.Board.start_link` function.
  Functions contained in this supervisor module will assist in the creation and retrieval of
  new board processes.
  Also note the guards utilizing `is_integer(board_id)` on the functions. My feeling here is that
  if someone makes a mistake and tries sending a string-based key or an atom, I'll just _"let it crash"_.
  """

  use Supervisor
  require Logger
  alias Bstk.{BoardRules, Board, TileNew, BoardServer}

  @board_registry_name :board_process_registry

  @doc """
  Starts the supervisor.
  """
  def start_link do
    IO.puts("start_link")
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end


  @doc """
  Will find the process identifier (in our case, the `board_id`) if it exists in the registry and
  is attached to a running `Bstk.BoardServer` process.
  If the `board_id` is not present in the registry, it will create a new `Bstk.BoardServer`
  process and add it to the registry for the given `board_id`.
  Returns a tuple such as `{:ok, board_id}` or `{:error, reason}`
  """
  def find_or_create_process(board_id) when is_integer(board_id) do
    if board_process_exists?(board_id) do
      {:ok, board_id}
    else
      board_id |> create_board_process
    end
  end


  @doc """
  Determines if a `Bstk.BoardServer` process exists, based on the `board_id` provided.
  Returns a boolean.
  ## Example
      iex> Bstk.BoardSupervisor.board_process_exists?(6)
      false
  """
  def board_process_exists?(board_id) when is_integer(board_id) do
    case Registry.lookup(@board_registry_name, board_id) do
      [] -> false
      _ -> true
    end
  end


  @doc """
  Creates a new board process, based on the `board_id` integer.
  Returns a tuple such as `{:ok, board_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_board_process(board_id) when is_integer(board_id) do
    IO.puts("creating new board process " <> Integer.to_string(board_id))

    #%{board_name: state_data.name, process_id: state_data.process_id, x: state_data.board.width, y: state_data.board.height}
    case Supervisor.start_child(__MODULE__, [board_id]) do
      {:ok, _pid} -> {:ok, board_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end


  @doc """
  Returns the count of `Bstk.Board` processes managed by this supervisor.
  ## Example
      iex> Bstk.BoardSupervisor.board_process_count
      0
  """
  def board_process_count, do: Supervisor.which_children(__MODULE__) |> length


  @doc """
  Return a list of `board_id` integers known by the registry.
  ex - `[1, 23, 46]`
  """
  def board_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, board_proc_pid, _, _} ->
      Registry.keys(@board_registry_name, board_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end


  @doc """
  Return a list of widgets ordered per board.
  The list will be made up of a map structure for each child board process.
  ex - `[%{board_id: 2, widgets_sold: 1}, %{board_id: 10, widgets_sold: 1}]`
  """
  def get_all_tiles do
    #board_ids() |> Enum.map(&(%{ board_id: &1, widgets_sold: Bstk.Board.widgets_ordered(&1) }))
  end


  @doc false
  def init(_) do
    IO.puts("BoardSupervisor Init")
    board_wrapper = %{
      process_id: 1,
      name: "main_gameboard",
      board: Board.new(12, 12, "main_gameboard", "system_generated_this_board_on_init"),
      rules: BoardRules.new(),
      players: []
    }

    {:ok, tile} = TileNew.new(:token)
    {:ok, tile2} = TileNew.new(:sticker)
    {:ok, tile3} = TileNew.new(:big_sticker)
    {:ok, tile4} = TileNew.new(:card)

    {:ok, new_board} = case Map.fetch(board_wrapper, :board) do
      {:ok, new_board} -> {:ok, _new_tile} = Board.place_tile(new_board, tile, {4, 5});
      :error -> {:ok, board_wrapper}
    end
    board_wrapper = Map.put(board_wrapper, :board, new_board);

    {:ok, new_board} = case Map.fetch(board_wrapper, :board) do
      {:ok, new_board} -> {:ok, _new_tile} = Board.place_tile(new_board, tile2, {9, 9});
      :error -> {:ok, board_wrapper}
    end
    board_wrapper = Map.put(board_wrapper, :board, new_board);

    {:ok, new_board} = case Map.fetch(board_wrapper, :board) do
      {:ok, new_board} -> {:ok, _new_tile} = Board.place_tile(new_board, tile3, {1, 1});
      :error -> {:ok, board_wrapper}
    end
    board_wrapper = Map.put(board_wrapper, :board, new_board);

    {:ok, new_board} = case Map.fetch(board_wrapper, :board) do
      {:ok, new_board} -> {:ok, _new_tile} = Board.place_tile(new_board, tile4, {8, 2});
      :error -> {:ok, board_wrapper}
    end
    board_wrapper = Map.put(board_wrapper, :board, new_board);


    board_wrapper2 = %{
      process_id: 2,
      name: "sub_board",
      board: Board.new(12, 12, "sub_board", "system_generated_this_board_on_init"),
      rules: BoardRules.new(),
      players: []
    }

    children = [
      worker(Bstk.BoardServer, [], restart: :permanent)
    ]


    :ets.insert(:game_state, {board_wrapper.process_id, board_wrapper})
    :ets.insert(:game_state, {board_wrapper2.process_id, board_wrapper2})
    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end
end
