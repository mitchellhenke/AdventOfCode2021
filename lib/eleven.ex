defmodule Adventofcode2021.Eleven do
  @external_resource "data/eleven.txt"

  @input File.read!("data/eleven.txt")
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

    Enum.reduce(1..100, {numbers, 0}, fn _n, {numbers, acc} ->
      {updated_map, flash_key_set} =
        Enum.reduce(numbers, {%{}, MapSet.new()}, fn {key, value}, {map, flash_key_set} ->
          if value + 1 > 9 do
            {Map.put(map, key, value + 1), MapSet.put(flash_key_set, key)}
          else
            {Map.put(map, key, value + 1), flash_key_set}
          end
        end)

      {updated_map, flash_key_set} = run_flashes(updated_map, flash_key_set, width, flash_key_set)
      {updated_map, acc + MapSet.size(flash_key_set)}
      # |> print_grid(width, n)
    end)
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

    Enum.reduce_while(1..1000, {numbers, 0}, fn n, {numbers, acc} ->
      {updated_map, flash_key_set} =
        Enum.reduce(numbers, {%{}, MapSet.new()}, fn {key, value}, {map, flash_key_set} ->
          if value + 1 > 9 do
            {Map.put(map, key, value + 1), MapSet.put(flash_key_set, key)}
          else
            {Map.put(map, key, value + 1), flash_key_set}
          end
        end)

      {updated_map, flash_key_set} = run_flashes(updated_map, flash_key_set, width, flash_key_set)

      Map.values(updated_map)
      |> Enum.all?(&(&1 == 0))
      |> if do
        {:halt, n}
      else
        {:cont, {updated_map, acc + MapSet.size(flash_key_set)}}
      end
    end)
  end

  def print_grid({map, set}, width, n) do
    IO.inspect("After step #{n}")

    Enum.sort_by(map, fn {key, _value} ->
      key
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.chunk_every(width)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()

    {map, set}
  end

  def run_flashes(updated_map, flash_key_set, width, total_flash_key_set) do
    {map, new_flash_key_set} =
      Enum.reduce(flash_key_set, {updated_map, MapSet.new()}, fn key, {map, new_flash_key_set} ->
        adjacent_keys = adjacent_indices(map, key, width)

        {map, new_flash_key_set} =
          Enum.reduce(adjacent_keys, {map, new_flash_key_set}, fn adjacent_key,
                                                                  {map, new_flash_key_set} ->
            {new_value, map} =
              if MapSet.member?(total_flash_key_set, adjacent_key) do
                {0, map}
              else
                Map.get_and_update!(map, adjacent_key, &{&1 + 1, &1 + 1})
              end

            if new_value > 9 && not MapSet.member?(total_flash_key_set, adjacent_key) do
              {map, MapSet.put(new_flash_key_set, adjacent_key)}
            else
              {map, new_flash_key_set}
            end
          end)

        map = Map.put(map, key, 0)
        {map, new_flash_key_set}
      end)

    if MapSet.size(new_flash_key_set) == 0 do
      {map, MapSet.union(flash_key_set, total_flash_key_set)}
    else
      run_flashes(
        map,
        new_flash_key_set,
        width,
        MapSet.union(new_flash_key_set, total_flash_key_set)
      )
    end
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

    up_right = x + 1 + width * (y - 1)
    up_left = x - 1 + width * (y - 1)
    down_right = x + 1 + width * (y + 1)
    down_left = x - 1 + width * (y + 1)

    cond do
      x == 0 && y == 0 ->
        [right, down, down_right]

      x == 0 && y == max_y ->
        [right, up, up_right]

      x == max_x && y == 0 ->
        [left, down, down_left]

      x == max_x && y == max_y ->
        [left, up, up_left]

      x == max_x ->
        [up, left, down, up_left, down_left]

      y == max_y ->
        [up, right, left, up_right, up_left]

      x == 0 ->
        [right, down, up, up_right, down_right]

      y == 0 ->
        [left, right, down, down_right, down_left]

      true ->
        [left, down, right, up, down_right, down_left, up_right, up_left]
    end
  end
end
