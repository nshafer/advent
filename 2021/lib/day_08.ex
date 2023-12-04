defmodule Advent.Day08 do
  # Part 1
  def count_simple_digits(entries) do
    entries
    |> parse_entries()
    |> Enum.flat_map(fn {_patterns, output} -> Enum.filter(output, &String.length(&1) in [2, 3, 4, 7]) end)
    |> Enum.count()
  end

  # Part 2
  def sum_entries(entries) do
    entries
    |> parse_entries()
    |> Enum.map(&unscramble_outputs/1)
    |> Enum.map(&translate_display/1)
    |> Enum.sum()
  end

  def unscramble_outputs({patterns, outputs}) do
    key = deduce_key(patterns)
    Enum.map(outputs, &translate_output(&1, key))
  end

  # Returns a map that has the scrambled segment letter pointing to the unscrambled segment letter
  def deduce_key(patterns) do
    %{}
    |> find_a(patterns)
    |> build_frequencies(patterns)
    |> find_by_frequency(:b, 6)
    |> find_by_frequency(:c, 8)
    |> find_by_frequency(:e, 4)
    |> find_by_frequency(:f, 9)
    |> find_d(patterns)
    |> find_g(patterns)
    |> Map.delete(:freq)
    |> invert_key()
  end

  def find_a(key, patterns) do
    # We can find 1 and 7 easy enough, and 7 has the top bar (a), but 1 does not
    d1 = Enum.find(patterns, &(MapSet.size(&1) == 2))
    d7 = Enum.find(patterns, &(MapSet.size(&1) == 3))

    Map.put(key, :a, MapSet.difference(d7, d1) |> Enum.at(0))
  end

  def build_frequencies(key = %{a: a}, patterns) do
    freq =
      patterns
      |> Enum.concat()
      |> Enum.frequencies()
      |> Enum.filter(fn {k, _v} -> k != a end)
      |> Enum.map(fn {k, v} -> {v, k} end)
      |> Enum.into(%{})

    Map.put(key, :freq, freq)
  end

  def find_by_frequency(%{freq: freq} = key, segment, frequency) do
    Map.put(key, segment, Map.fetch!(freq, frequency))
  end

  def find_d(key, patterns) do
    # We can find the 0, 6, and 9, and since 6 is missing c, and 9 is missing e, we can
    # whittle that down to get 0, then compare that with 8 to find the d segment
    d8 = Enum.find(patterns, &(MapSet.size(&1) == 7))
    d069 = Enum.filter(patterns, &(MapSet.size(&1) == 6))
    [d0] =
      d069
      |> Enum.reject(&(not MapSet.member?(&1, key.c)))
      |> Enum.reject(&(not MapSet.member?(&1, key.e)))

    Map.put(key, :d, MapSet.difference(d8, d0) |> Enum.at(0))
  end

  def find_g(key, patterns) do
    # Since there's only one left, just remove all of the ones we found, what remains is g
    found =
      key
      |> Map.values()
      |> Enum.filter(&is_binary/1)
      |> MapSet.new()

    [g] =
      patterns
      |> Enum.concat()
      |> Enum.uniq()
      |> Enum.reject(fn x -> MapSet.member?(found, x) end)

    Map.put(key, :g, g)
  end

  def invert_key(key) do
    for {k, v} <- key, into: %{} do
      {v, to_string(k)}
    end
  end

  def translate_output(output, key) do
    output
    |> String.graphemes()
    |> Enum.map(&(Map.fetch!(key, &1)))
    |> Enum.sort()
    |> Enum.join()
  end

  def translate_display(displays) do
    displays
    |> Enum.map(&display_to_int/1)
    |> Integer.undigits()
  end

  def display_to_int("abcefg"), do: 0
  def display_to_int("cf"), do: 1
  def display_to_int("acdeg"), do: 2
  def display_to_int("acdfg"), do: 3
  def display_to_int("bcdf"), do: 4
  def display_to_int("abdfg"), do: 5
  def display_to_int("abdefg"), do: 6
  def display_to_int("acf"), do: 7
  def display_to_int("abcdefg"), do: 8
  def display_to_int("abcdfg"), do: 9

  # Utils
  def parse_entries(entries) do
    entries
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(fn [patterns, outputs] -> {parse_patterns(patterns), parse_outputs(outputs)} end)
  end

  def parse_patterns(patterns) do
    patterns
    |> String.split()
    |> Enum.map(&parse_pattern/1)
  end

  def parse_pattern(pattern) do
    pattern
    |> String.split("", trim: true)
    |> MapSet.new()
  end

  def parse_outputs(outputs) do
    outputs
    |> String.split()
  end
end
