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
    Application.app_dir(:advent, Path.join(["priv", filename]))
  end
end
