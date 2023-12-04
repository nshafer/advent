defmodule AdventDay09Test do
  use ExUnit.Case, async: true

  @input_path "day_09/heightmap.txt"

  test "part 1" do
    assert Advent.Day09.sum_risk_levels(@input_path) == 462
  end

  test "part 2" do
    assert Advent.Day09.sum_three_largest_basins(@input_path) == 1397760
  end
end
