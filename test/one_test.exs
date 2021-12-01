defmodule AdventOneTest do
  use ExUnit.Case

  test "part 1" do
    depths = Advent.load_ints("depths.txt")
    assert Advent.One.count_depth_increases(depths) == 1462
  end

  test "part 2" do
    depths = Advent.load_ints("depths.txt")
    assert Advent.One.count_depth_increases_by_window(depths) == 1497
  end
end
