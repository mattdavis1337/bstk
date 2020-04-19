defmodule Bstk.GameTimer do
  use GenServer

  alias BandstockEngine.TileGame
  #@board_registry_name :game_timer_process_registry

  @timeout 100  #repeat every .1 second

  def start_link(queue_name) do
    GenServer.start_link(__MODULE__, queue_name, name: __MODULE__)
  end

  def init(queue_name) do
    #{:ok, engine} = TileGame.Engine.start_link([])

    {:ok, %{queue_name: queue_name, clock: {System.monotonic_time(), 0}, games: []}, @timeout}
  end

  def handle_info(:timeout, state) do
    IO.inspect(state)
    {prevTime, _elapsed} = state.clock;
    time = System.monotonic_time(:millisecond);
    {:ok, game} = Bstk.BoardSupervisor.find_or_create_process(1)

    #TileGame.Engine.say(state.engine, {time, time-prevTime});

    #TileGame.Engine.pulse(state.engine, {time, time-prevTime});

    #GenServer.cast(state.engine, {:say, {time, time-prevTime}})
    state = Map.replace!(state, :clock, {time, time-prevTime});
    Bstk.BoardServer.player_joined(game, genhash(8));
    board_state = Bstk.BoardServer.get_state(1);

    #BandstockEngine.Engine.say(state.engine, "yes")

    #IO.inspect(Bstk.BoardServer.get_state(1));
    {:noreply, state, @timeout}
  end

  defp genhash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
