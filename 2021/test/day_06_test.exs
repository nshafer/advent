defmodule AdventDay06Test do
  use ExUnit.Case, async: true

  @input_path "day_06/fish.txt"

  test "part 1" do
    fish = Advent.load_list_ints(@input_path)
    assert Advent.Day06.calculate_growth_rate(fish, 80) == 380612
  end

  test "part 2" do
    fish = Advent.load_list_ints(@input_path)
    assert Advent.Day06.calculate_growth_rate(fish, 256) == 1710166656900
  end
end
