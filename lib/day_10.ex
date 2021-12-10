defmodule Advent.Day10 do
  # Part 1
  def score_corrupted_lines(lines) do
    lines
    |> Stream.map(&check_line/1)
    |> Stream.filter(&match?({:corrupt, _}, &1))
    |> Stream.map(&score_result/1)
    |> Enum.sum()
  end

  # Part 2
  def score_incomplete_lines(lines) do
    scores =
      lines
      |> Stream.map(&check_line/1)
      |> Stream.filter(&match?({:incomplete, _}, &1))
      |> Stream.map(&score_result/1)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  # Utils
  def check_line(line, buf \\ "")
  def check_line("", ""), do: :ok
  def check_line("", buf) when byte_size(buf) > 0, do: {:incomplete, buf}

  def check_line(<<c, rest::binary>>, buf) when c in ~c/([{</ do
    check_line(rest, <<c>> <> buf)
  end

  def check_line(<<c, _rest::binary>>, "") when c in ~c/)]}>/, do: {:corrupt, <<c>>}
  def check_line(<<c, rest::binary>>, <<b, buf::binary>>) when c in ~c/)]}>/ do
    case is_match?(b, c) do
      true -> check_line(rest, buf)
      false -> {:corrupt, <<c>>}
    end
  end

  def is_match?(?(, ?)), do: true
  def is_match?(?[, ?]), do: true
  def is_match?(?{, ?}), do: true
  def is_match?(?<, ?>), do: true
  def is_match?(_, _), do: false

  def score_result(:ok), do: 0

  def score_result({:corrupt, ")" <> _rest}), do: 3
  def score_result({:corrupt, "]" <> _rest}), do: 57
  def score_result({:corrupt, "}" <> _rest}), do: 1197
  def score_result({:corrupt, ">" <> _rest}), do: 25137

  def score_result({:incomplete, buf}) do
    buf
    |> String.codepoints()
    |> Enum.map(fn
      "(" -> 1
      "[" -> 2
      "{" -> 3
      "<" -> 4
    end)
    |> Enum.reduce(0, fn points, sum -> sum * 5 + points end)
  end
end
