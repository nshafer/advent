defmodule Advent.Day06 do
  # Part 1 & 2
  @spec calculate_growth_rate([integer], integer) :: integer
  def calculate_growth_rate(fish, days) do
    for _day <- 1..days, reduce: Enum.frequencies(fish) do
      fish -> do_day(fish)
    end
    |> Map.values()
    |> Enum.sum()
  end

  defp do_day(fish) do
    # Manually unroll updates to the map. Each fish is advanced closer to 0.
    # Fish already at 0 get reset to 6, and create a new fish at 8.
    %{
      0 => Map.get(fish, 1, 0),
      1 => Map.get(fish, 2, 0),
      2 => Map.get(fish, 3, 0),
      3 => Map.get(fish, 4, 0),
      4 => Map.get(fish, 5, 0),
      5 => Map.get(fish, 6, 0),
      6 => Map.get(fish, 7, 0) + Map.get(fish, 0, 0),
      7 => Map.get(fish, 8, 0),
      8 => Map.get(fish, 0, 0),
    }
  end
end
