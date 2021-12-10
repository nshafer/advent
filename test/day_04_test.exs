defmodule AdventDay04Test do
  use ExUnit.Case, async: true

  @input_path "day_04/input.txt"

  test "part 1" do
    plays = Advent.Day04.load_plays(@input_path)
    boards = Advent.Day04.load_boards(@input_path)
    assert Advent.Day04.bingo(boards, plays) == 35670
  end

  test "part 2" do
    plays = Advent.Day04.load_plays(@input_path)
    boards = Advent.Day04.load_boards(@input_path)
    assert Advent.Day04.bingo2(boards, plays) == 22704
  end
end
