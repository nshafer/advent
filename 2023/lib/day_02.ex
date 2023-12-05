defmodule Day02 do
  # Part 1

  def count_possible(games, maxes) do
    parse_games(games)
    |> Enum.filter(fn {_, pulls} -> all_possible?(pulls, maxes) end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def all_possible?(pulls, maxes) do
    Enum.all?(pulls, fn pull -> pull_possible?(pull, maxes) end)
  end

  def pull_possible?(pull, maxes) do
    Enum.all?(pull, fn {color, num} -> num <= Map.get(maxes, color) end)
  end

  # Part 2

  def pow_game_mins(games) do
    parse_games(games)
    |> Enum.map(fn {_id, pulls} -> find_mins(pulls) end)
    |> Enum.map(fn mins -> Map.values(mins) end)
    |> Enum.map(fn counts -> Enum.product(counts) end)
    |> Enum.sum()
  end

  def find_mins(pulls) do
    for pull <- pulls, reduce: %{} do
      acc ->
        for {color, num} <- pull, reduce: acc do
          acc -> Map.update(acc, color, num, fn existing -> max(num, existing) end)
        end
    end
  end

  # Parsing

  def parse_games(games) do
    for game <- games, reduce: %{} do
      acc ->
        {id, pulls} = parse_game(game)
        Map.put(acc, id, pulls)
    end
  end

  defp parse_game(game) do
    [_, id, game_text] = Regex.run(~r/^Game (\d+): (.*)$/, game)
    pulls = parse_game_text(game_text)

    {String.to_integer(id), pulls}
  end

  defp parse_game_text(game_text) do
    for pull_text <- String.split(game_text, ";"), reduce: [] do
      acc -> [parse_pull_text(pull_text) | acc]
    end
  end

  defp parse_pull_text(pull_text) do
    for pull <- String.split(pull_text, ","), reduce: %{} do
      acc ->
        [_, num, color] = Regex.run(~r/(\d+)\s+(\w+)/, pull)
        Map.put(acc, color, String.to_integer(num))
    end
  end
end
