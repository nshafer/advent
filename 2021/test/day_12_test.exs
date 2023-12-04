defmodule AdventDay12Test do
  use ExUnit.Case, async: true

  @input_path "day_12/caves.txt"

  test "part 1" do
    caves = Advent.Day12.load_caves(@input_path)
    assert Advent.Day12.count_paths(caves) == 3802
  end

  test "part 2" do
    caves = Advent.Day12.load_caves(@input_path)
    assert Advent.Day12.count_paths2(caves) == 99448
  end
end
