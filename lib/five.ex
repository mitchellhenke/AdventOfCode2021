defmodule Adventofcode2021.Five do
  @external_resource "data/five.txt"
  @input File.read!("data/five.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn line ->
           [begin, ending] = String.split(line, " -> ")

           begin_x_y =
             String.split(begin, ",")
             |> Enum.map(&String.to_integer(&1))

           end_x_y =
             String.split(ending, ",")
             |> Enum.map(&String.to_integer(&1))

           [begin_x_y, end_x_y]
         end)

  def first do
    Enum.filter(@input, fn [[x1, y1], [x2, y2]] ->
      x1 == x2 || y1 == y2
    end)
    |> Enum.reduce(%{}, fn [[x1, y1], [x2, y2]], count_map ->
      Enum.reduce(x1..x2, count_map, fn x, count_map ->
        Enum.reduce(y1..y2, count_map, fn y, count_map ->
          Map.update(count_map, {x, y}, 1, &(&1 + 1))
        end)
      end)
    end)
    |> Enum.filter(fn {_key, value} ->
      value > 1
    end)
  end

  def second do
    Enum.reduce(@input, %{}, fn [[x1, y1], [x2, y2]], count_map ->
      points = Enum.max([abs(x2 - x1), abs(y2 - y1)])

      Enum.reduce(0..points, count_map, fn n, count_map ->
        x =
          cond do
            x1 == x2 ->
              x1

            x2 > x1 ->
              x1 + n

            x2 < x1 ->
              x1 - n
          end

        y =
          cond do
            y1 == y2 ->
              y1

            y2 > y1 ->
              y1 + n

            y2 < y1 ->
              y1 - n
          end

        Map.update(count_map, {x, y}, 1, &(&1 + 1))
      end)
    end)
    |> Enum.filter(fn {_key, value} ->
      value > 1
    end)
  end
end
