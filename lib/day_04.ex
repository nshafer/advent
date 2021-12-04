defmodule Advent.Day04 do
  defmodule Board do
    defstruct [:numbers, :marked, :index]

    def new() do
      %__MODULE__{
        numbers: init_board(),
        marked: init_board(),
        index: nil
      }
    end

    def new(numbers) do
      %__MODULE__{
        numbers: numbers,
        marked: init_board(),
        index: index(numbers),
      }
    end

    def init_board() do
      %{
        0 => %{0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil},
        1 => %{0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil},
        2 => %{0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil},
        3 => %{0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil},
        4 => %{0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil},
      }
    end

    def mark_number(board, {i, j}) do
      put_in(board.marked[i][j], true)
    end

    def mark_number(board, number) do
      case get_location(board, number) do
        nil -> board
        {i, j} -> mark_number(board, {i, j})
      end
    end

    def index(board) do
      for {i, row} <- board, {j, number} <- row, into: %{} do
        {number, {i, j}}
      end
    end

    def has_number?(%{index: nil}, _number), do: false
    def has_number?(%{index: index}, number) do
      Map.has_key?(index, number)
    end

    def get_location(%{index: nil}, _number), do: nil
    def get_location(%{index: index}, number) do
      Map.get(index, number, nil)
    end

    def get_marked_row(board, i) do
      Enum.map(board.marked[i], fn {_j, v} -> v end)
    end

    def get_marked_column(board, j) do
      Enum.map(board.marked, fn {_i, row} -> row[j] end)
    end

    def is_solved?(board) do
      has_solved_row?(board) || has_solved_column?(board)
    end

    def has_solved_row?(board) do
      Enum.any?(0..4, fn i -> get_marked_row(board, i) == [true, true, true, true, true] end)
    end

    def has_solved_column?(board) do
      Enum.any?(0..4, fn j -> get_marked_column(board, j) == [true, true, true, true, true] end)
    end

    def get_unmarked_numbers(board) do
      for i <- 0..4, j <- 0..4, board.marked[i][j] == nil do
        board.numbers[i][j]
      end
    end

    def score(board, last_play) do
      sum =
        get_unmarked_numbers(board)
        |> Stream.map(&String.to_integer/1)
        |> Enum.sum()

      sum * String.to_integer(last_play)
    end
  end

  # Part 1
  def bingo(boards, plays) do
    case find_winning_board(boards, plays) do
      {_round, last_play, board} -> Board.score(board, last_play)
      nil -> nil
    end
  end

  def find_winning_board(boards, plays) do
    boards
    |> Enum.map(fn board -> find_solution(board, plays) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sort()
    |> List.first(nil)
  end

  def find_solution(board, plays, round \\ 0)
  def find_solution(_board, [], _round), do: nil
  def find_solution(board, [play | plays], round) do
    board = Board.mark_number(board, play)

    if Board.is_solved?(board) do
      # return the round it was found on, the last play that solved it, and the filled in board itself
      {round, play, board}
    else
      find_solution(board, plays, round + 1)
    end
  end

  # Part 2
  def bingo2(boards, plays) do
    case find_losing_board(boards, plays) do
      {_round, last_play, board} -> Board.score(board, last_play)
      nil -> nil
    end
  end

  def find_losing_board(boards, plays) do
    boards
    |> Enum.map(fn board -> find_solution(board, plays) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sort()
    |> List.last(nil)
  end

  # Utils
  def open_input(filename) do
    Advent.input_path(filename)
    |> File.open!([:read, :utf8])
  end

  def load_plays(filename) do
    open_input(filename)
    |> IO.read(:line)
    |> String.trim()
    |> String.split(",", trim: true)
  end

  def load_boards(filename) do
    input = open_input(filename)

    # skip the first two lines, which are the plays and a blank
    IO.read(input, :line)
    IO.read(input, :line)

    read_boards(input, [])
  end

  def read_boards(input, boards) do
    case read_board(input) do
      :eof -> boards
      board -> read_boards(input, [Board.new(board) | boards])
    end
  end

  def read_board(input) do
    for _i <- 0..5, line = IO.read(input, :line), line not in [:eof, "", "\n"] do
      parse_line(line)
    end
    |> convert_to_indexed_map()
  end

  def parse_line(line) do
    line
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> convert_to_indexed_map()
  end

  def convert_to_indexed_map([]), do: :eof
  def convert_to_indexed_map(list) do
    list
    |> Enum.with_index(fn element, index -> {index, element} end)
    |> Map.new()
  end
end
