defmodule AdventDay10Test do
  use ExUnit.Case, async: true

  @input_path "day_10/lines.txt"

  test "part 1" do
    lines = Advent.load_inputs(@input_path)
    assert Advent.Day10.score_corrupted_lines(lines) == 216297
  end

  test "part 2" do
    lines = Advent.load_inputs(@input_path)
    assert Advent.Day10.score_incomplete_lines(lines) == 2165057169
  end
end
