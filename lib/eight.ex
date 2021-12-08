defmodule Adventofcode2021.Eight do
  @external_resource "data/eight.txt"

  @input File.read!("data/eight.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn line ->
           [inputs, output] = String.split(line, " | ")

           inputs =
             String.split(inputs, " ")
             |> Enum.map(&(String.graphemes(&1) |> Enum.sort() |> MapSet.new()))

           outputs =
             String.split(output, " ")
             |> Enum.map(&(String.graphemes(&1) |> Enum.sort() |> MapSet.new()))

           [inputs, outputs]
         end)

  def first do
    @input
    |> Enum.map(fn [_inputs, outputs] ->
      Enum.count(outputs, fn output ->
        Enum.member?([2, 4, 3, 7], MapSet.size(output))
      end)
    end)
    |> Enum.sum()
  end

  def second do
    @input
    |> Enum.map(fn [inputs, outputs] ->
      one = Enum.find(inputs, &(Enum.count(&1) == 2))
      four = Enum.find(inputs, &(Enum.count(&1) == 4))
      seven = Enum.find(inputs, &(Enum.count(&1) == 3))
      eight = Enum.find(inputs, &(Enum.count(&1) == 7))

      right_segments = MapSet.intersection(one, seven)

      top_segment = MapSet.difference(seven, one)

      three =
        Enum.filter(inputs, fn input ->
          MapSet.subset?(MapSet.union(right_segments, top_segment), input) &&
            MapSet.size(input) == 5
        end)
        |> hd()

      nine =
        Enum.filter(inputs, fn input ->
          MapSet.subset?(four, input) && MapSet.size(input) == 6
        end)
        |> hd()

      five =
        Enum.filter(inputs, fn input ->
          MapSet.subset?(input, nine) && MapSet.size(input) == 5 &&
            input != three
        end)
        |> hd()

      zero =
        Enum.filter(inputs, fn input ->
          MapSet.subset?(seven, input) && MapSet.size(input) == 6 &&
            input != nine
        end)
        |> hd()

      two =
        Enum.filter(inputs, fn input ->
          MapSet.size(input) == 5 &&
            !Enum.any?([three, five], &(input == &1))
        end)
        |> hd()

      six =
        Enum.filter(inputs, fn input ->
          MapSet.size(input) == 6 &&
            !Enum.any?([zero, nine], &(input == &1))
        end)
        |> hd()

      map = %{
        zero => 0,
        one => 1,
        two => 2,
        three => 3,
        four => 4,
        five => 5,
        six => 6,
        seven => 7,
        eight => 8,
        nine => 9
      }

      Enum.map(outputs, fn output ->
        Map.fetch!(map, output)
      end)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end
end
