defmodule BstkRulesTest do
  use ExUnit.Case
  #alias Bstk.{Rules}
  doctest Bstk


  # defp setup_rules do
  #   Rules.new()
  # end

  # @tag :pending
  # test "add a player" do
  #   rules = setup_rules()
  #   {:ok, rules} = Rules.check(rules, :add_player)
  #   assert rules.state == :players_set
  # end
  #
  # @tag :pending
  # test "player1 sets islands" do
  #   rules = setup_rules()
  #   {:ok, rules} = Rules.check(rules, :add_player)
  #
  #   {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
  #   assert rules.player1 == :islands_set
  #   assert rules.player2 == :islands_not_set
  #   assert rules.state == :players_set
  # end
  #
  # @tag :pending
  # test "both players sets islands" do
  #   rules = setup_rules()
  #   {:ok, rules} = Rules.check(rules, :add_player)
  #   {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
  #   {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
  #
  #   assert rules.player1 == :islands_set
  #   assert rules.player2 == :islands_set
  #   assert rules.state == :player1_turn
  # end






end


# %Bstk.Rules{
#   player1: :islands_not_set,
#   player2: :islands_not_set,
#   state: :initialized
# }
# iex(17)> rules = %{rules | state: :players_set}
# %Bstk.Rules{
#   player1: :islands_not_set,
#   player2: :islands_not_set,
#   state: :players_set
# }
# iex(18)> {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
# {:ok,
#  %Bstk.Rules{
#    player1: :islands_set,
#    player2: :islands_not_set,
#    state: :players_set
#  }}
# iex(19)> {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
# {:ok,
#  %Bstk.Rules{
#    player1: :islands_set,
#    player2: :islands_not_set,
#    state: :players_set
#  }}
# iex(20)> rules.state
# :players_set
# iex(21)> Rules.check(rules, {:position_islands, :player1})
# :error
# iex(22)> {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
# {:ok,
#  %Bstk.Rules{
#    player1: :islands_set,
#    player2: :islands_not_set,
#    state: :players_set
#  }}
# iex(23)> rules.state
# :players_set
# iex(24)> {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
# {:ok,
#  %Bstk.Rules{player1: :islands_set, player2: :islands_set, state: :player1_turn}}
# iex(25)> rules.state
# :player1_turn
# iex(26)> Rules.check(rules, :add_player)
# :error
# iex(27)>
