defmodule Adventofcode2021.Two do
  @external_resource "data/two.txt"
  @steps File.read!("data/two.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn line ->
           [direction, count] = String.split(line, " ")
           [direction, String.to_integer(count)]
         end)
  def first do
    [final_horizontal, final_depth] =
      Enum.reduce(@steps, [0, 0], fn [direction, amount], [horizontal, depth] ->
        case direction do
          "forward" ->
            [horizontal + amount, depth]

          "up" ->
            [horizontal, depth - amount]

          "down" ->
            [horizontal, depth + amount]
        end
      end)

    final_horizontal * final_depth
  end

  def second do
    [final_horizontal, final_depth, _final_aim] =
      Enum.reduce(@steps, [0, 0, 0], fn [direction, amount], [horizontal, depth, aim] ->
        case direction do
          "forward" ->
            [horizontal + amount, depth + aim * amount, aim]

          "up" ->
            [horizontal, depth, aim - amount]

          "down" ->
            [horizontal, depth, aim + amount]
        end
      end)
      |> IO.inspect()

    final_horizontal * final_depth
  end
end
