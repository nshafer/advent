defmodule AdventDay03Test do
  use ExUnit.Case

  test "part 1" do
    binaries = Advent.load_inputs("day_03/binaries.txt")
    {gamma, epsilon} = Advent.Day03.calc_diagnostics(binaries, 12)
    assert gamma == 2484
    assert epsilon == 1611
    assert gamma * epsilon == 4001724
  end

  test "part 2" do
    binaries = Advent.load_inputs("day_03/binaries.txt")
    {oxygen, co2} = Advent.Day03.calc_life_support(binaries, 12)
    assert oxygen == 2545
    assert co2 == 231
    assert oxygen * co2 == 587895
  end
end
