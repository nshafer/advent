defmodule AdventDay05Test do
  use ExUnit.Case, async: true

  @input_path "day_05/lines.txt"

  test "part 1" do
    lines = Advent.Day05.load_lines(@input_path)
    assert Advent.Day05.count_horizontal_intersections(lines) == 7269
  end

  test "part 2" do
    lines = Advent.Day05.load_lines(@input_path)
    assert Advent.Day05.count_intersections(lines) == 21140
  end
end
