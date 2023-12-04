defmodule Advent.Day13 do
  # Part 1
  def count_dots_after_one_fold(paper, [fold | _folds]) do
    paper
    |> do_fold(fold)
    |> Matrix.values()
    |> Enum.frequencies()
    |> Map.get(1)
  end

  # Part 2
  def fold_paper(paper, folds) do
    folds
    |> Enum.reduce(paper, fn fold, paper -> do_fold(paper, fold) end)
    |> IO.puts
  end

  # Utils
  def do_fold(paper, {:x, loc}) do
    # first create a new paper that is width - loc
    folded = Matrix.new(paper.width - loc, paper.height, 0)

    # Copy all of the dots left of the fold
    folded =
      for x <- 0..loc-1, y <- 0..paper.height-1, reduce: folded do
        folded -> Matrix.put(folded, x, y, paper[{x, y}])
      end

    # Copy all of the dots right of the fold to their reflected coordinate
    for x <- loc+1..paper.width-1, y <- 0..paper.height-1, reduce: folded do
      folded ->
        reflected_x = loc - (x - loc)
        combined = max(folded[{reflected_x, y}], paper[{x, y}])
        Matrix.put(folded, reflected_x, y, combined)
    end
  end

  def do_fold(paper, {:y, loc}) do
    # first create a new paper that is height - loc
    folded = Matrix.new(paper.width, paper.height - loc, 0)

    # Copy all of the dots above the fold
    folded =
      for x <- 0..paper.width-1, y <- 0..loc-1, reduce: folded do
        folded -> Matrix.put(folded, x, y, paper[{x, y}])
      end

    # Copy all of the dots below the fold to their reflected coordinate
    for x <- 0..paper.width-1, y <- loc+1..paper.height-1, reduce: folded do
      folded ->
        reflected_y = loc - (y - loc)
        combined = max(folded[{x, reflected_y}], paper[{x, y}])
        Matrix.put(folded, x, reflected_y, combined)
    end
  end

  def load_input(filename) do
    [dots, folds] =
      filename
      |> Advent.input_path()
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    {parse_dots(dots), parse_folds(folds)}
  end

  def parse_dots(dots) do
    dots =
      dots
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn [x, y] -> [String.to_integer(x), String.to_integer(y)] end)

    max_x = Enum.max(dots, fn [x1, _y1], [x2, _y2] -> x1 > x2 end) |> Enum.at(0)
    max_y = Enum.max(dots, fn [_x1, y1], [_x2, y2] -> y1 > y2 end) |> Enum.at(1)

    paper = Matrix.new(max_x+1, max_y+1, 0)

    dots
    |> Enum.reduce(paper, fn [x, y], paper ->
      Matrix.put(paper, x, y, 1)
    end)
  end

  def parse_folds(folds) do
    folds
    |> Enum.map(fn instruction ->
      [_m, dir, loc] = Regex.run(~r/fold along (\w+)=(\d+)/, instruction)

      {String.to_atom(dir), String.to_integer(loc)}
    end)
  end
end
