defmodule Advent.Day01 do
  # Part 1
  def count_depth_increases(depths) do
    depths
    |> Enum.reduce({nil, 0}, &determine_increase/2)
    |> elem(1)
  end

  defp determine_increase(depth, {nil, acc}), do: {depth, acc}
  defp determine_increase(depth, {prev, acc}) when depth > prev, do: {depth, acc + 1}
  defp determine_increase(depth, {_prev, acc}), do: {depth, acc}

  # Part 2
  def count_depth_increases_by_window(depths) do
    depths
    |> Enum.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
    |> count_depth_increases()
  end
end
