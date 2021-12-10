defmodule Advent.Day09 do
  # Part 1
  def sum_risk_levels(filename) do
    load_heightmap(filename)
    |> find_low_points()
    |> Stream.map(fn {_x, _y, h} -> 1 + h end)
    |> Enum.sum()
  end

  def find_low_points(heightmap) do
    for y <- 0..map_size(heightmap)-1, x <- 0..map_size(Map.get(heightmap, y))-1, is_lowpoint?(heightmap, x, y) do
      {x, y, heightmap[y][x]}
    end
  end

  def is_lowpoint?(heightmap, x, y) do
    height = heightmap[y][x]

    heightmap
    |> find_adjacent_heights(x, y)
    |> Stream.filter(&(not is_nil(&1)))
    |> Enum.all?(fn {_x, _y, h} -> height < h end)
  end

  def find_adjacent_heights(heightmap, x, y) do
    [
      get_height(heightmap, x, y-1),
      get_height(heightmap, x+1, y),
      get_height(heightmap, x, y+1),
      get_height(heightmap, x-1, y),
    ]
  end

  def get_height(heightmap, x, y) do
    with(
      {:ok, row} <- Map.fetch(heightmap, y),
      {:ok, h} <- Map.fetch(row, x)
    ) do
      {x, y, h}
    else
      :error -> nil
    end
  end

  # Part 2
  def sum_three_largest_basins(filename) do
    heightmap = load_heightmap(filename)

    find_low_points(heightmap)
    |> Stream.map(&find_basin(heightmap, &1))
    |> Stream.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def find_basin(heightmap, p = {x, y, _h}, counted \\ MapSet.new()) do
    counted = MapSet.put(counted, p)

    find_adjacent_heights(heightmap, x, y)
    |> Stream.filter(&(not is_nil(&1)))
    |> Enum.reduce(counted, fn e = {_x, _y, h}, counted ->
      if h != 9 and not MapSet.member?(counted, e) do
        find_basin(heightmap, e, counted)
      else
        counted
      end
    end)
  end

  # Utils
  def load_heightmap(filename) do
    Advent.load_inputs(filename)
    |> Stream.map(&parse_heightmap_line/1)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.into(%{})
  end

  def parse_heightmap_line(line) do
    line
    |> String.split("", trim: true)
    |> Stream.map(&String.to_integer(&1))
    |> Enum.with_index(&({&2, &1}))
    |> Enum.into(%{})
  end
end
