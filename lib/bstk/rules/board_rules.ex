defmodule Bstk.BoardRules do
  alias __MODULE__

  defstruct game_state: :game_state@welcoming_players

  def new(), do: %BoardRules{}

  def check(%BoardRules{game_state: :game_state@showing_boards} = board_rules, :user_action@select_board) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@editing_board }}
  end

  def check(%BoardRules{game_state: :game_state@welcoming_players} = board_rules, :user_action@add_player) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@welcoming_players}}
  end

  def check(%BoardRules{game_state: :game_state@welcoming_players} = board_rules, :user_action@remove_player) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@welcoming_players}}
  end

  def check(%BoardRules{game_state: :game_state@welcoming_players} = board_rules, :user_action@place_token) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@welcoming_players}}
  end


  def check(%BoardRules{game_state: :state@initialized} = board_rules, :game_action@welcome_user) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@welcoming_user }}
  end

  def check(_state, _action), do: :error
end
