defmodule AdventDay08Test do
  use ExUnit.Case, async: true

  @input_path "day_08/entries.txt"

  test "part 1" do
    entries = Advent.load_inputs(@input_path)
    assert Advent.Day08.count_simple_digits(entries) == 554
  end

  test "part 2" do
    entries = Advent.load_inputs(@input_path)
    assert Advent.Day08.sum_entries(entries) == 990964
  end
end
