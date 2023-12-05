defmodule Day02Test do
  use ExUnit.Case, async: true

  test "part 1" do
    games = Advent.load_inputs("day_02/games.txt")
    maxes = %{"red" => 12, "green" => 13, "blue" => 14}
    assert Day02.count_possible(games, maxes) == 2285
  end

  test "part 2" do
    games = Advent.load_inputs("day_02/games.txt")
    assert Day02.pow_game_mins(games) == 77021
  end
end
