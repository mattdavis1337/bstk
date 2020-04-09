defmodule Bstk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Bstk.Worker.start_link(arg)
      # {Bstk.Worker, arg},
      supervisor(Registry, [:unique, :board_process_registry]),
      supervisor(Bstk.BoardSupervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(:game_state, [:public, :named_table])
    opts = [strategy: :one_for_one, name: Bstk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
