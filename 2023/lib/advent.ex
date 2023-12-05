defmodule Advent do
  def load_inputs(filename) do
    input_path(filename)
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  def load_ints(filename, base \\ 10) do
    load_inputs(filename)
    |> Enum.map(&String.to_integer(&1, base))
  end

  def load_list(filename) do
    input_path(filename)
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
  end

  def load_list_ints(filename, base \\ 10) do
    load_list(filename)
    |> Enum.map(&String.to_integer(&1, base))
  end

  def input_path(filename) do
    Application.app_dir(:advent, ["priv", filename])
  end

  # def load_matrix(filename, opts \\ []) do
  #   split_by = Keyword.get(opts, :split_by, ~r/\s+/)
  #   parser = Keyword.get(opts, :parser, nil)

  #   for row <- load_inputs(filename) do
  #     for v <- String.split(row, split_by, trim: true) do
  #       maybe_parse_input(v, parser)
  #     end
  #   end
  #   |> Matrix.new()
  # end

  def maybe_parse_input(v, nil), do: v
  def maybe_parse_input(v, parser), do: parser.(v)
end
