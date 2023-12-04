defmodule Advent.Day12 do
  defmodule Cave do
    defstruct name: nil, type: nil, conns: MapSet.new()
  end

  # Part 1
  def count_paths(caves) do
    find_paths(caves, Map.fetch!(caves, "start"), &update_visited/2, &can_visit/2)
    |> Enum.count()
  end

  def update_visited(visited, node) do
    Map.update(visited, node.name, 1, fn visit_count -> visit_count + 1 end)
  end

  def can_visit(%Cave{type: :large}, _visited), do: true
  def can_visit(%Cave{type: :small, name: name}, visited) do
    not Map.has_key?(visited, name)
  end

  # Part 2
  def count_paths2(caves) do
    find_paths(caves, Map.fetch!(caves, "start"), &update_visited2/2, &can_visit2/2)
    |> Enum.count()
  end

  def update_visited2(visited, node) do
    visited = Map.update(visited, node.name, 1, fn visit_count -> visit_count + 1 end)
    visit_count = Map.fetch!(visited, node.name)
    if node.type == :small and visit_count >= 2 do
      Map.put(visited, :small_cave_already_visited_twice, true)
    else
      visited
    end
  end

  def can_visit2(%Cave{name: "start"}, _visited), do: false
  def can_visit2(%Cave{type: :large}, _visited), do: true
  def can_visit2(%Cave{type: :small} = node, visited) do
    small_cave_already_visited_twice = Map.get(visited, :small_cave_already_visited_twice, false)

    case Map.get(visited, node.name) do
      nil -> true
      n when n < 1 -> true
      n when n < 2 and not small_cave_already_visited_twice -> true
      _ -> false
    end
  end

  # Utils
  def find_paths(caves, node, update, filter, path \\ [], visited \\ Map.new())
  def find_paths(_caves, %Cave{name: "end"}, _update, _filter, path, _visited), do: ["end" | path] |> Enum.reverse() |> Enum.join(",")
  def find_paths(caves, node, update, filter, path, visited) do
    # update visited with the number of times each node has been visited
    visited = update.(visited, node)

    possible_connections =
      node.conns
      |> Enum.map(&Map.fetch!(caves, &1))
      |> Enum.filter(&filter.(&1, visited))

    case possible_connections do
      [] -> nil
      conns ->
        for conn <- conns do
          find_paths(caves, conn, update, filter, [node.name | path], visited)
        end
        |> Enum.reject(&is_nil/1)
        |> List.flatten()
    end
  end

  def load_caves(filename) do
    Advent.load_inputs(filename)
    |> parse_caves()
  end

  def parse_caves(line) do
    line
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], caves -> parse_cave(caves, a, b) end)
  end

  def parse_cave(caves, a, b) do
    {caves, a} = put_new_and_get(caves, a)
    {caves, b} = put_new_and_get(caves, b)

    connect_caves(caves, a, b)
  end

  def put_new_and_get(caves, name) do
    caves = Map.put_new(caves, name, %Cave{name: name, type: determine_cave_type(name)})
    cave = Map.fetch!(caves, name)

    {caves, cave}
  end

  def connect_caves(caves, a, b) do
    caves
    |> Map.put(a.name, %Cave{a | conns: MapSet.put(a.conns, b.name)})
    |> Map.put(b.name, %Cave{b | conns: MapSet.put(b.conns, a.name)})
  end

  def determine_cave_type(name) do
    cond do
      String.downcase(name) == name -> :small
      String.upcase(name) == name -> :large
      true -> raise "invalid cave: #{name}"
    end
  end
end
