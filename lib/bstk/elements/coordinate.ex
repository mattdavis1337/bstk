defmodule Bstk.Coordinate do
  alias __MODULE__
  alias Bstk.{Coordinate}

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @board_range 0..119 #square board

  def new(x, y) when x in(@board_range) and y in(@board_range), do:
    {:ok, %Coordinate{x: x, y: y}}

  def new(_x, _y), do: {:error, :invalid_coordinate}

end
