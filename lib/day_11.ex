defmodule Advent.Day11 do
  # Part 1
  def count_flashes(%Matrix{} = octos, steps) do
    {_octos, flashes} = do_n_steps(octos, steps)

    flashes
  end

  def do_n_steps(octos, steps, step \\ 0, flashes \\ 0)
  def do_n_steps(octos, steps, step, flashes) when step == steps, do: {octos, flashes}
  def do_n_steps(octos, steps, step, flashes) do
    {octos, flashes_this_step} = do_step(octos)

    do_n_steps(octos, steps, step + 1, flashes + flashes_this_step)
  end

  # Part 2
  def find_first_synchronized_flash(octos) do
    do_step_until_synchronized(octos)
  end

  def do_step_until_synchronized(octos, step \\ 0) do
    case Matrix.cardinality(octos) do
      1 -> step
      _ ->
        {octos, _flashes} = do_step(octos)
        do_step_until_synchronized(octos, step + 1)
    end
  end

  # Utils
  def do_step(octos) do
    octos
    |> increment_energy()
    |> do_flashes()
    |> reset_and_count_flashed()
  end

  def increment_energy(octos) do
    for {x, y, energy} <- octos, reduce: octos do
      octos -> put_in(octos[{x, y}], energy + 1)
    end
  end

  def do_flashes(octos, flashed \\ MapSet.new()) do
    case Enum.find(octos, fn {x, y, v} -> v > 9 and not MapSet.member?(flashed, {x, y}) end) do
      nil -> octos
      octo = {x, y, _v} ->
        octos = do_flash(octos, octo)
        flashed = MapSet.put(flashed, {x, y})
        do_flashes(octos, flashed)
    end
  end

  def do_flash(octos, {x, y, _v}) do
    for {x, y, v} <- Matrix.adjacents(octos, x, y, diagonals: true), reduce: octos do
      octos -> Matrix.put(octos, x, y, v + 1)
    end
  end

  def reset_and_count_flashed(octos) do
    for {x, y, v} <- octos, v > 9, reduce: {octos, 0} do
      {octos, flashes} -> {Matrix.put(octos, x, y, 0), flashes + 1}
    end
  end
end
