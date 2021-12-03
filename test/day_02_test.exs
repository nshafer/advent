defmodule AdventDay02Test do
  use ExUnit.Case

  test "part 1" do
    directions = Advent.load_inputs("day_02/directions.txt")
    position = Advent.Day02.get_position1(directions)
    assert position.horiz == 1980
    assert position.depth == 951
    assert position.horiz * position.depth == 1882980
  end

  test "part 2" do
    directions = Advent.load_inputs("day_02/directions.txt")
    position = Advent.Day02.get_position2(directions)
    assert position.horiz == 1980
    assert position.depth == 995572
    assert position.horiz * position.depth == 1971232560
  end
end
