defmodule Matrix do
  @moduledoc """
  Implements a basic 2-dimensional matrix of any width and any height. Includes a few helper functions and also
  conforms to the Access behaviour as well as implements the String.Chars, Inspect and Enumerable protocols.

  Most functions allow passing explicit x and y values, or a shorter version passing a coordinate tuple of {x, y}.
  This is especially useful when using the Access protocol, such as `my_matrix[{2, 3}]` or
  `put_in(my_matrix[{5,1}], "new value")`.

  Does not do much checking on input... use with care.
  """

  defstruct [m: %{}, width: 0, height: 0, index: %{}]

  @behaviour Access

  @doc """
  Creates a new matrix of width and height with every element initialized to value
  """
  def new(width, height, value) do
    for _y <- 0..height-1 do
      for _x <- 0..width-1 do
        value
      end
    end
    |> new()
  end

  @doc """
  Creates a new matrix from a 2-dimensional array of lists.
  It should be a list of rows, and each row is a list of elements.
  """
  def new(lists) when is_list(lists) do
    {m, width, height, index} =
      lists
      |> Stream.with_index()
      |> Stream.flat_map(fn {row, y} ->
        row
        |> Stream.with_index()
        |> Stream.map(fn {v, x} ->
          {x, y, v}
        end)
      end)
      |> Enum.reduce({%{}, 0, 0, %{}}, fn {x, y, v}, {m, width, height, index} ->
        m = Map.update(m, x, %{y => v}, fn n -> Map.put(n, y, v) end)
        width = max(width, x + 1)
        height = max(height, y + 1)
        index = Map.update(index, v, MapSet.new([{x, y}]), fn locations -> MapSet.put(locations, {x, y}) end)

        {m, width, height, index}
      end)

    %__MODULE__{m: m, width: width, height: height, index: index}
  end

  @doc """
  Puts value in the matrix at the x and y coordinates.

  Returns :out_of_bounds if attempting to put an element outside of the matrix.
  """
  def put(matrix, x, _y, _value) when x < 0 or x >= matrix.width, do: :out_of_bounds
  def put(matrix, _x, y, _value) when y < 0 or y >= matrix.height, do: :out_of_bounds

  def put(matrix, x, y, value) do
    old_value = get(matrix, x, y)
    m = put_in(matrix.m, [x, y], value)
    index = update_index(matrix.index, x, y, old_value, value)
    %__MODULE__{matrix | m: m, index: index}
  end

  @doc """
  Puts value in the matrix at the coordinate tuple {x, y}.

  Returns :out_of_bounds if attempting to put an element outside of the matrix.
  """
  def put(matrix, {x, y}, value), do: put(matrix, x, y, value)
  def put(_matrix, _key, _value), do: raise KeyError

  defp update_index(index, x, y, old_value, new_value) do
    index
    |> maybe_remove_old_value_from_index(x, y, old_value)
    |> Map.update(new_value, MapSet.new([{x, y}]), fn locations -> MapSet.put(locations, {x, y}) end)
  end

  defp maybe_remove_old_value_from_index(index, _x, _y, nil), do: index
  defp maybe_remove_old_value_from_index(index, x, y, old_value) do
    locations = Map.get(index, old_value)
    case MapSet.size(locations) do
      1 -> Map.delete(index, old_value)
      _ -> Map.put(index, old_value, MapSet.delete(locations, {x, y}))
    end
  end

  @doc """
  Fetch value at x, y. Returns {:ok, value} or :error if not found.
  """
  def fetch(matrix, x, y) do
    with(
      {:ok, col} <- Map.fetch(matrix.m, x),
      {:ok, val} <- Map.fetch(col, y)
    ) do
      {:ok, val}
    end
  end

  @doc """
  Fetch value at x, y. Returns value or raises KeyError.
  """
  def fetch!(matrix, x, y) do
    case fetch(matrix, x, y) do
      {:ok, value} -> value
      :error -> raise KeyError
    end
  end

  @doc """
  Fetch value at coordinate tuple {x, y}. Returns {:ok, value} or :error if not found.
  """
  @impl true
  def fetch(matrix, {x, y}), do: fetch(matrix, x, y)
  def fetch(_matrix, _key), do: :error

  @doc """
  Fetch value at coordinate tuple {x, y}. Returns value or raises KeyError.
  """
  def fetch!(matrix, {x, y}), do: fetch!(matrix, x, y)

  @doc """
  Gets value at x, y and returns it or else default.
  """
  def get(matrix, x, y, default \\ nil) do
    case fetch(matrix, x, y) do
      {:ok, val} -> val
      :error -> default
    end
  end

  @doc """
  Get value and x, y and pass it to fun. The function must return {current_value, new_value}.

  See Map.get_and_update/3 for more information.
  """
  def get_and_update(matrix, x, y, fun) do
    current_value = get(matrix, x, y)

    case fun.(current_value) do
      {get, update} -> {get, put(matrix, x, y, update)}
      :pop -> raise "cannot pop a Matrix"
    end
  end

  @doc """
  Get value and coordinate {x, y} and pass it to fun. The function must return {current_value, new_value}.

  See Map.get_and_update/3 for more information.
  """
  @impl true
  def get_and_update(matrix, {x, y}, fun), do: get_and_update(matrix, x, y, fun)

  @doc """
  Popping from a matrix is not allowed, raises an exception.
  """
  @impl true
  def pop(_matrix, _key) do
    raise "cannot pop a Matrix"
  end

  @doc """
  Returns a list of all distinct values in the matrix, no repeats.
  """
  def distinct_values(matrix) do
    Map.keys(matrix.index)
  end

  @doc """
  Returns the cardinality of the matrix, in other words how many distinct values.
  """
  def cardinality(matrix) do
    map_size(matrix.index)
  end

  @doc """
  Returns a list of elements in the matrix in the form of a cell {x, y, value}.
  """
  def to_list(matrix) do
    for x <- 0..matrix.width-1, y <- 0..matrix.height-1 do
      {x, y, matrix.m[x][y]}
    end
  end

  @doc """
  Returns the size of the matrix, which is just width * height
  """
  def size(matrix) do
    matrix.width * matrix.height
  end

  @doc """
  Returns a list of adjacent cells to the given element in the form {x, y, value}.

  Will not return cells outside of the bounds of the matrix.

  Pass the option `diagonals: true` to include diagonals, otherwise it's only orthogonal cells.
  """
  def adjacents(matrix, x, y, opts \\ []) do
    diagonals? = Keyword.get(opts, :diagonals, false)

    adjacents =
      if diagonals? do
        [{x, y-1}, {x+1, y-1}, {x+1, y}, {x+1, y+1}, {x, y+1}, {x-1, y+1}, {x-1, y}, {x-1, y-1}]
      else
        [{x, y-1}, {x+1, y}, {x, y+1}, {x-1, y}]
      end

    adjacents
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x >= matrix.width or y >= matrix.height end)
    |> Enum.map(fn {x, y} -> {x, y, matrix.m[x][y]} end)
  end
end

defimpl String.Chars, for: Matrix do
  def to_string(matrix) do
    max_length =
      matrix.index
      |> Map.keys()
      |> Enum.map(&Kernel.to_string/1)
      |> Enum.max_by(&String.length/1)
      |> String.length()

    for y <- 0..matrix.height-1 do
      for x <- 0..matrix.width-1 do
        String.pad_trailing(Kernel.to_string(matrix.m[x][y]), max_length)
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end
end

defimpl Inspect, for: Matrix do
  import Inspect.Algebra

  def inspect(matrix, opts) do
    concat(["#Matrix<", to_doc(matrix.width, opts), ",", to_doc(matrix.height, opts), line(), inspect_grid(matrix, opts), ">"])
  end

  def inspect_grid(matrix, opts) do
    for y <- 0..matrix.height-1 do
      for x <- 0..matrix.width-1 do
        to_doc(matrix.m[x][y], opts)
      end
      |> Enum.intersperse(break("\t"))
      |> concat()
      |> group()
      |> concat(line())
    end
    |> concat()
  end
end

defimpl Enumerable, for: Matrix do
  def count(matrix) do
    {:ok, Matrix.size(matrix)}
  end

  def member?(_matrix, _element) do
    {:error, __MODULE__}
  end

  def reduce(matrix, acc, fun) do
    Enumerable.List.reduce(Matrix.to_list(matrix), acc, fun)
  end

  def slice(matrix) do
    size = Matrix.size(matrix)
    {:ok, size, &Enumerable.List.slice(Matrix.to_list(matrix), &1, &2, size)}
  end
end
