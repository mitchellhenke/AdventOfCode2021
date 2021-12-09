defmodule Adventofcode2021.Nine do
  @external_resource "data/nine.txt"

  @input File.read!("data/nine.txt")
         |> String.split("\n", trim: true)

  def first do
    width = hd(@input) |> String.length()

    numbers =
      Enum.map(@input, &String.graphemes/1)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {n, index} ->
        {index, n}
      end)
      |> Enum.into(%{})

    length = map_size(numbers)

    values =
      Enum.reduce(0..(length - 1), [], fn index, low_point_indices ->
        value = Map.fetch!(numbers, index)

        adjacent_indices =
          adjacent_indices(numbers, index, width)
          |> Enum.map(&Map.fetch!(numbers, &1))

        if Enum.all?(adjacent_indices, &(value < &1)) do
          [index | low_point_indices]
        else
          low_point_indices
        end
      end)
      |> Enum.map(&Map.fetch!(numbers, &1))

    Enum.sum(values) + Enum.count(values)
  end

  def second do
    width = hd(@input) |> String.length()

    numbers =
      Enum.map(@input, &String.graphemes/1)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {n, index} ->
        {index, n}
      end)
      |> Enum.into(%{})

    length = map_size(numbers)

    low_point_indices =
      Enum.reduce(0..(length - 1), [], fn index, low_point_indices ->
        value = Map.fetch!(numbers, index)

        adjacent_indices =
          adjacent_indices(numbers, index, width)
          |> Enum.map(&Map.fetch!(numbers, &1))

        if Enum.all?(adjacent_indices, &(value < &1)) do
          [index | low_point_indices]
        else
          low_point_indices
        end
      end)

    Enum.map(low_point_indices, fn index ->
      build_basin(numbers, [index], width, MapSet.new([index]))
    end)
    |> Enum.sort_by(&(MapSet.size(&1) * -1))
    |> Enum.take(3)
    |> Enum.reduce(1, fn set, acc ->
      acc * MapSet.size(set)
    end)
  end

  def build_basin(_numbers, [], _width, current_basin_set) do
    current_basin_set
  end

  def build_basin(numbers, [index | rest], width, current_basin_set) do
    adjacent_indices =
      adjacent_indices(numbers, index, width)
      |> Enum.reduce([], fn index, valid_indices ->
        value = Map.fetch!(numbers, index)

        if value < 9 && !MapSet.member?(current_basin_set, index) &&
             !MapSet.member?(current_basin_set, index) do
          [index | valid_indices]
        else
          valid_indices
        end
      end)

    new_current_basin = MapSet.union(MapSet.new(adjacent_indices), current_basin_set)
    build_basin(numbers, adjacent_indices ++ rest, width, new_current_basin)
  end

  def adjacent_indices(numbers, index, width) do
    length = map_size(numbers)
    x = rem(index, width)
    y = div(index, width)

    max_x = width - 1
    max_y = div(length, width) - 1

    up = x + width * (y - 1)

    down = x + width * (y + 1)

    left = x - 1 + width * y

    right = x + 1 + width * y

    cond do
      x == 0 && y == 0 ->
        [right, down]

      x == 0 && y == max_y ->
        [right, up]

      x == max_x && y == 0 ->
        [left, down]

      x == max_x && y == max_y ->
        [left, up]

      x == max_x ->
        [up, left, down]

      y == max_y ->
        [up, right, left]

      x == 0 ->
        [right, down, up]

      y == 0 ->
        [left, right, down]

      true ->
        [left, down, right, up]
    end
  end
end
