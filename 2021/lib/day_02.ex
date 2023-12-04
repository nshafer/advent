defmodule Advent.Day02 do
  # Part 1
  defmodule Position1 do
    defstruct horiz: 0, depth: 0
  end

  def get_position1(directions) do
    directions
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [cmd, n] -> [cmd, String.to_integer(n)] end)
    |> Enum.reduce(%Position1{}, fn
      ["forward", n], pos -> %{pos | horiz: pos.horiz + n}
      ["down", n], pos -> %{pos | depth: pos.depth + n}
      ["up", n], pos -> %{pos | depth: pos.depth - n}
    end)
  end

  # Part 2
  defmodule Position2 do
    defstruct horiz: 0, depth: 0, aim: 0
  end

  def get_position2(directions) do
    directions
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [cmd, n] -> [cmd, String.to_integer(n)] end)
    |> Enum.reduce(%Position2{}, fn
      ["forward", n], pos -> %{pos | horiz: pos.horiz + n, depth: pos.depth + pos.aim * n}
      ["down", n], pos -> %{pos | aim: pos.aim + n}
      ["up", n], pos -> %{pos | aim: pos.aim - n}
    end)
  end
end
