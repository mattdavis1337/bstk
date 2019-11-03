# defmodule Bstk.IslandRules do
#   alias __MODULE__
#
#   defstruct state: :state@initialized,
#     player1: :status@islands_not_set,
#     player2: :status@islands_not_set
#
#   def new(), do: %Rules{}
#
#   def check(%Rules{state: :state@player1_turn} = rules, {:action@win_check, win_or_not}) do
#     case win_or_not do
#       :no_win -> {:ok, rules}
#       :win -> {:ok, %Rules{rules | state: :state@game_over}}
#     end
#   end
#
#   def check(%Rules{state: :state@player1_turn} = rules, {:action@guess_coordinate, :player1}), do:
#     {:ok, %Rules{rules | state: :state@player2_turn}}
#
#   def check(%Rules{state: :state@player2_turn} = rules, {:action@guess_coordinate, :player2}), do:
#     {:ok, %Rules{rules | state: :state@player1_turn}}
#
#   def check(%Rules{state: :state@players_set} = rules, {:action@set_islands, player}) do
#     rules = Map.put(rules, player, :status@islands_set)
#     case both_players_islands_set?(rules) do
#       true -> {:ok, %Rules{rules | state: :state@player1_turn}}
#       false -> {:ok, rules}
#     end
#   end
#
#   def check(%Rules{state: :state@players_set} = rules, {:action@position_islands, player}) do
#     case Map.fetch!(rules, player) do
#       :status@islands_set -> :error
#       :status@islands_not_set -> {:ok, rules}
#     end
#   end
#
#   def check(%Rules{state: :state@initialized} = rules, :action@add_player), do:
#     {:ok, %Rules{rules | state: :state@players_set}}
#
#   def check(_state, _action), do: :error
#
#   defp both_players_islands_set?(rules), do:
#     rules.player1 == :status@islands_set && rules.player2 == :status@islands_set
# end
