defmodule Day01 do
  @digits_re ~r/(\d)/
  @words_re ~r/(\d|zero|one|two|three|four|five|six|seven|eight|nine)/

  def sum_calibration_values_1(lines) do
    do_sum(lines, @digits_re)
  end

  def sum_calibration_values_2(lines) do
    do_sum(lines, @words_re)
  end

  defp do_sum(lines, re) do
    for line <- lines do
      with(
        a <- find_first_digit(line, re),
        b <- find_last_digit(line, re)
      ) do
        String.to_integer("#{parse_digit(a)}#{parse_digit(b)}")
      end
    end
    |> Enum.sum()
  end

  defp find_first_digit(line, re) do
    do_find(line, re, 1, :left)
  end

  defp find_last_digit(line, re) do
    do_find(line, re, String.length(line) - 1, :right)
  end

  defp do_find(line, re, split_at, dir) do
    {a, b} = String.split_at(line, split_at)

    if dir == :left do
      case Regex.run(re, a) do
        [_, digit] -> digit
        _ -> do_find(line, re, split_at + 1, dir)
      end
    else
      case Regex.run(re, b) do
        [_, digit] -> digit
        _ -> do_find(line, re, split_at - 1, dir)
      end
    end
  end

  defp parse_digit(digit) do
    case digit do
      "zero" -> "0"
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      digit -> digit
    end
  end
end
