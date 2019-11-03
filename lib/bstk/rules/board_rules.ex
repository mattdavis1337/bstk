defmodule Bstk.BoardRules do
  alias __MODULE__

  defstruct game_state: :state@initialized

  def new(), do: %BoardRules{}

  def check(%BoardRules{game_state: :game_state@showing_boards} = board_rules, :user_action@select_board) do
    {:ok, %BoardRules{board_rules | game_state: :game_state@editing_board }}
  end

  def check(%BoardRules{game_state: :game_state@welcoming_user} = board_rules, :user_action@view_user_boards), do:
    {:ok, %BoardRules{board_rules | game_state: :game_state@showing_boards }}

  def check(%BoardRules{game_state: :state@initialized} = board_rules, :game_action@welcome_user), do:
    {:ok, %BoardRules{board_rules | game_state: :game_state@welcoming_user }}

  def check(_state, _action), do: :error

end
