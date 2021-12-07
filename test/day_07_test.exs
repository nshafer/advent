defmodule AdventDay07Test do
  use ExUnit.Case

  @input_path "day_07/crabs.txt"

  test "part 1" do
    crabs = Advent.load_list_ints(@input_path)
    assert Advent.Day07.find_position(crabs) == 351901
  end

  test "part 2" do
    crabs = Advent.load_list_ints(@input_path)
    assert Advent.Day07.find_position2(crabs) == 101079875
  end
end
