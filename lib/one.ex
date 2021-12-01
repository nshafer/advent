defmodule Advent.One do
  def count_depth_increases(depths) do
    depths
    |> Enum.reduce({nil, 0}, &determine_increase/2)
    |> elem(1)
  end

  defp determine_increase(depth, {nil, acc}), do: {depth, acc}
  defp determine_increase(depth, {prev, acc}) when depth > prev, do: {depth, acc + 1}
  defp determine_increase(depth, {_prev, acc}), do: {depth, acc}
end
