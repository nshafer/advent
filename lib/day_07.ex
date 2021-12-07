defmodule Advent.Day07 do
  # Part 1
  def find_position(crabs) do
    Enum.min(crabs)..Enum.max(crabs)
    |> Stream.map(fn p -> Enum.reduce(crabs, 0, &(abs(p - &1) + &2)) end)
    |> Enum.min()
  end

  # Part 2
  def find_position2(crabs) do
    Enum.min(crabs)..Enum.max(crabs)
    |> Stream.map(fn p -> Enum.reduce(crabs, 0, &(calc_fuel(p, &1) + &2)) end)
    |> Enum.min()
  end

  def calc_fuel(p1, p2) do
    n = abs(p1 - p2)
    div(n * (n + 1), 2)
  end
end
