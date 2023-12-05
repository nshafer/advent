defmodule Day01Test do
  use ExUnit.Case, async: true

  test "part 1" do
    lines = Advent.load_inputs("day_01/calibrations.txt")
    assert Day01.sum_calibration_values_1(lines) == 54331
  end

  test "part 2" do
    lines = Advent.load_inputs("day_01/calibrations.txt")
    assert Day01.sum_calibration_values_2(lines) == 54518
  end
end
