defmodule Bstk.TimeScale do
  def now(_) do
    DateTime.utc_now()
  end

  def speedup do
    86400
  end
end
