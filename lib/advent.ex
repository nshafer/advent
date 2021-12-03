defmodule Advent do
  def load_inputs(filename) do
    input_path(filename)
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  def load_ints(filename, base \\ 10) do
    load_inputs(filename)
    |> Enum.map(fn s -> String.to_integer(s, base) end)
  end

  def input_path(filename) do
    Application.app_dir(:advent, Path.join(["priv", filename]))
  end
end
