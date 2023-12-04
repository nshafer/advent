defmodule Advent.Day03 do
  # Part 1

  @spec calc_diagnostics([String.t], integer) :: {gamma :: integer, epsilon :: integer}
  def calc_diagnostics(binaries, length) do
    frequencies = calc_digit_frequencies(binaries, length)

    {calc_by_fun(frequencies, &Kernel.>/2), calc_by_fun(frequencies, &Kernel.<=/2)}
  end

  @spec calc_digit_frequencies([String.t], integer) :: [Map.t]
  defp calc_digit_frequencies(binaries, length) do
    binaries
    |> Stream.map(&String.graphemes/1)
    |> Stream.flat_map(&Enum.with_index/1)
    |> Enum.frequencies()
    |> shape_frequencies(length)
  end

  defp shape_frequencies(frequencies, length) do
    for i <- 0..length-1, into: [] do
      for d <- ["0", "1"], into: %{} do
        {d, Map.get(frequencies, {d, i}, 0)}
      end
    end
  end

  # fun/2 takes the frequency of the "0" digits, and frequency of the "1" digits and must
  # return true to keep 0, false to keep 1
  defp calc_by_fun(frequencies, fun) do
    frequencies
    |> Enum.map(fn dist -> if fun.(dist["0"], dist["1"]), do: 0, else: 1 end)
    |> Integer.undigits(2)
  end

  # Part 2
  @spec calc_life_support([String.t], integer) :: {oxygen_generator_rating :: integer, co2_scrubber_rating :: integer}
  def calc_life_support(binaries, length) do
    {
      filter_binaries_by_fun(binaries, length, 0, &Kernel.>/2),
      filter_binaries_by_fun(binaries, length, 0, &Kernel.<=/2)
    }
  end

  # fun/2 takes the frequency of the "0" digits, and frequency of the "1" digits and must
  # return true to filter by "0", false to filter by "1" in that place
  defp filter_binaries_by_fun([binary], _length, _i, _fun), do: String.to_integer(binary, 2)
  defp filter_binaries_by_fun(binaries, length, i, fun) do
    frequencies = calc_digit_frequencies(binaries, length)
    frequency = Enum.at(frequencies, i)
    target_digit = if fun.(frequency["0"], frequency["1"]), do: "0", else: "1"
    matching_binaries = Enum.filter(binaries, fn binary -> String.slice(binary, i, 1) == target_digit end)
    filter_binaries_by_fun(matching_binaries, length, i + 1, fun)
  end
end
