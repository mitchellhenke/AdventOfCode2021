defmodule Adventofcode2021.Six do
  @external_resource "data/six.txt"
  @fish File.read!("data/six.txt")
        |> String.split("\n", trim: true)
        |> hd()
        |> String.split(",")
        |> Enum.map(&String.to_integer(&1))

  def first do
    Enum.reduce(1..80, @fish, fn _n, fish_school ->
      Enum.reduce(fish_school, [], fn fish, fish_school ->
        if fish == 0 do
          [6 | [8 | fish_school]]
        else
          [fish - 1 | fish_school]
        end
      end)
    end)
  end

  def second do
    map =
      Enum.reduce(@fish, %{}, fn fish, map ->
        Map.update(map, fish, 1, &(&1 + 1))
      end)

    Enum.reduce(1..256, map, fn _n, day_map ->
      Enum.reduce(day_map, %{}, fn {key, value}, new_map ->
        if key == 0 do
          Map.update(new_map, 6, value, &(&1 + value))
          |> Map.update(8, value, &(&1 + value))
        else
          Map.update(new_map, key - 1, value, &(&1 + value))
        end
      end)
    end)
  end
end
