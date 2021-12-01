defmodule AdventOneTest do
  use ExUnit.Case

  test "solution" do
    depths = Advent.load_ints("depths.txt")
    increases = Advent.One.count_depth_increases(depths)
    assert increases == 1462
  end
end
