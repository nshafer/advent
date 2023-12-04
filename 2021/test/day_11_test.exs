defmodule AdventDay11Test do
  use ExUnit.Case, async: true

  @input_path "day_11/octos.txt"

  test "part 1" do
    octos = Advent.load_matrix(@input_path, split_by: "", parser: &String.to_integer/1)
    assert Advent.Day11.count_flashes(octos, 100) == 1747
  end

  test "part 2" do
    octos = Advent.load_matrix(@input_path, split_by: "", parser: &String.to_integer/1)
    assert Advent.Day11.find_first_synchronized_flash(octos) == 505
  end
end
