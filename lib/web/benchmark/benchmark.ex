defmodule Benchmark do

  # My solution
  def alex(xs, acc \\ [])
  def alex([x, y | xs], acc), do: alex(xs, [{x, y} | acc])
  def alex(_, acc), do: Map.new(acc)

  # nietaki's solution
  def nietaki(xs) do
    xs
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Map.new()
  end

  # Sheharyar's solution
  def sheharyar(xs) do
    xs
    |> Enum.chunk_every(2, 2, :discard)
    |> Map.new(fn [x, y] -> {x, y} end)
  end

  # Patrick's solution
  def patrick(xs) do
    xs
    |> Enum.chunk_every(2, 2,:discard)
    |> Enum.into(%{}, fn [x, y] -> {x, y} end)
  end

  # Your solution
  def chip(xs) do
    Enum.reduce(xs, %{}, fn(item, acc) ->
      case Map.get(acc, :last) do
        nil ->
          Map.put(acc, :last, item)
        last ->
          acc = Map.put(acc, item, last)
          Map.drop(acc, [:last])
      end
    end)
  end

  # Function to do the time benchmarks.
  def timed(f, list, times \\ 10) do
    tests =
      for _ <- 0..times do
        :timer.tc(fn -> apply(__MODULE__, f, [list]) end) |> elem(0)
      end
    avg = Enum.sum(tests) / times
    {f, avg}
  end

  # Test function.
  def test(list, times \\ 10) do
    list = Enum.to_list(list)
    [:alex, :chip, :patrick, :nietaki, :sheharyar]
    |> Stream.map(fn f -> timed(f, list, times) end)
    |> Enum.sort(fn {_, x}, {_, y} -> x < y end)
  end
end
