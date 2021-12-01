defmodule Adventofcode2021.One do
  @external_resource "data/one.txt"
  @numbers File.read!("data/one.txt")
           |> String.split("\n", trim: true)
           |> Enum.map(&String.to_integer(&1))
  def first do
    # Chunk list of numbers [x1, x2, x3] into [[x1, x2], [x2, x3]] with :discard to drop leftovers
    @numbers
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x1, x2] ->
      x2 > x1
    end)
  end

  def second do
    # Chunk list of numbers [x1, x2, x3, x4] into [[x1, x2], [x2, x3], [x3, x4] with :discard to drop leftovers
    # and then chunk again into [[[x1, x2], [x2, x3]], [[x2, x3], [x3, x4]]
    @numbers
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [list1, list2] ->
      Enum.sum(list2) > Enum.sum(list1)
    end)
  end
end
