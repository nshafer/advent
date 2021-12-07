defmodule Advent.Day07 do
  # Part 1
  def find_position(crabs) do
    Enum.min(crabs)..Enum.max(crabs)
    |> Enum.map(fn i -> {Enum.map(crabs, &abs(i - &1)), i} end)
    |> Enum.map(fn {moves, i} -> {Enum.sum(moves), i} end)
    |> Enum.sort()
    |> List.first()
    |> elem(0)
  end

  # Part 2
  def find_position2(crabs) do
    Enum.min(crabs)..Enum.max(crabs)
    |> Enum.map(fn i -> {Enum.map(crabs, &calc_fuel(i, &1)), i} end)
    |> Enum.map(fn {moves, i} -> {Enum.sum(moves), i} end)
    |> Enum.sort()
    |> List.first()
    |> elem(0)
  end

  def calc_fuel(p1, p2) do
    n = abs(p1 - p2)
    div(n * (n + 1), 2)
  end
end
