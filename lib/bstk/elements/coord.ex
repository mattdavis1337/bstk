defmodule Bstk.Coord do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]
  @type t :: %__MODULE__{
    x: integer,
    y: integer
  }
end
