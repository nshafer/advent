defmodule AdventDay01Test do
  use ExUnit.Case, async: true

  test "part 1" do
    depths = Advent.load_ints("day_01/depths.txt")
    assert Advent.Day01.count_depth_increases(depths) == 1462
  end

  test "part 2" do
    depths = Advent.load_ints("day_01/depths.txt")
    assert Advent.Day01.count_depth_increases_by_window(depths) == 1497
  end
end
