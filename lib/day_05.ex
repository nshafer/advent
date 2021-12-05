defmodule Advent.Day05 do
  defmodule Line do
    defstruct p1: {0, 0}, p2: {0, 0}

    def new(p1 = {_, _}, p2 = {_, _}), do: %__MODULE__{p1: p1, p2: p2}

    def is_horizontal?(%Line{p1: {p1x, p1y}, p2: {p2x, p2y}}) do
      p1x == p2x or p1y == p2y
    end

    def get_all_points(%Line{p1: {p1x, p1y}, p2: {p2x, p2y}} = line) do
      if is_horizontal?(line) do
        for x <- p1x..p2x, y <- p1y..p2y do
          {x, y}
        end
      else
        walk_line(line, direction(line), [])
      end
    end

    defp walk_line(%Line{p1: {p1x, p1y} = p, p2: p}, _direction, points), do: [{p1x, p1y} | points]
    defp walk_line(%Line{p1: {p1x, p1y}, p2: p2}, {xf, yf} = direction, points) do
      walk_line(%Line{p1: {p1x + xf, p1y + yf}, p2: p2}, direction, [{p1x, p1y} | points])
    end

    def direction(line), do: {x_direction(line), y_direction(line)}

    def x_direction(%Line{p1: {p1x, _p1y}, p2: {p2x, _p2y}}), do: if p2x > p1x, do: 1, else: -1

    def y_direction(%Line{p1: {_p1x, p1y}, p2: {_p2x, p2y}}), do: if p2y > p1y, do: 1, else: -1
  end

  # Part 1
  def count_horizontal_intersections(lines) do
    lines
    |> Stream.filter(fn line -> Line.is_horizontal?(line) end)
    |> Enum.flat_map(fn line -> Line.get_all_points(line) end)
    |> Enum.frequencies()
    |> Stream.filter(fn {_point, count} -> count > 1 end)
    |> Enum.count()
  end

  # Part 2
  def count_intersections(lines) do
    lines
    |> Enum.flat_map(fn line -> Line.get_all_points(line) end)
    |> Enum.frequencies()
    |> Stream.filter(fn {_point, count} -> count > 1 end)
    |> Enum.count()
  end

  # Utils
  def load_lines(filename) do
    Advent.load_inputs(filename)
    |> Enum.map(fn line -> String.split(line, " -> ") end)
    |> Enum.map(fn [p1, p2] -> Line.new(parse_point(p1), parse_point(p2)) end)
  end

  def parse_point(point) do
    point
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
