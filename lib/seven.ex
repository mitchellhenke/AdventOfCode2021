defmodule Adventofcode2021.Seven do
  @external_resource "data/seven.txt"
  @numbers File.read!("data/seven.txt")
           |> String.split("\n", trim: true)
           |> hd()
           |> String.split(",")
           |> Enum.map(&String.to_integer(&1))

  def first do
    range = Enum.min(@numbers)..Enum.max(@numbers)

    Enum.reduce(range, {nil, nil}, fn n, {min_n, min_sum} ->
      sum =
        Enum.map(@numbers, &abs(&1 - n))
        |> Enum.sum()

      if is_nil(min_sum) || sum < min_sum do
        {n, sum}
      else
        {min_n, min_sum}
      end
    end)
  end

  def second do
    range = Enum.min(@numbers)..Enum.max(@numbers)

    Enum.reduce(range, {nil, nil}, fn n, {min_n, min_sum} ->
      sum =
        Enum.map(@numbers, fn num ->
          abs(num - n) * (abs(num - n) + 1) / 2
        end)
        |> Enum.sum()
        |> round()

      if is_nil(min_sum) || sum < min_sum do
        {n, sum}
      else
        {min_n, min_sum}
      end
    end)
  end
end
