defmodule Adventofcode2021.Ten do
  @external_resource "data/ten.txt"

  @input File.read!("data/ten.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.graphemes/1)

  def first do
    @input
    |> Enum.map(fn line ->
      process_line(line, [])
    end)
    |> Enum.filter(fn result ->
      elem(result, 0) == :error
    end)
    |> Enum.map(fn {:error, input, _stack, _expected} ->
      hd(input)
      |> case do
        ")" ->
          3

        "]" ->
          57

        "}" ->
          1197

        ">" ->
          25137
      end
    end)
    |> Enum.sum()
  end

  def second do
    @input
    |> Enum.map(fn line ->
      process_line(line, [])
    end)
    |> Enum.filter(fn result ->
      elem(result, 0) == :incomplete
    end)
    |> Enum.map(fn {:incomplete, stack} ->
      Enum.map(stack, &expected_character/1)
      |> Enum.reduce(0, fn character, acc ->
        acc = acc * 5

        case character do
          ")" ->
            acc + 1

          "]" ->
            acc + 2

          "}" ->
            acc + 3

          ">" ->
            acc + 4
        end
      end)
    end)
    |> Enum.sort()
    |> median()
  end

  def process_line([], []), do: :ok
  def process_line([], stack), do: {:incomplete, stack}

  def process_line([next | rest], stack) do
    cond do
      next in ["(", "[", "{", "<"] ->
        process_line(rest, [next | stack])

      matching_pair?(hd(stack), next) ->
        process_line(rest, tl(stack))

      true ->
        {:error, [next | rest], stack, expected_character(hd(stack))}
    end
  end

  def matching_pair?("(", ")"), do: true
  def matching_pair?("[", "]"), do: true
  def matching_pair?("{", "}"), do: true
  def matching_pair?("<", ">"), do: true
  def matching_pair?(_a, _b), do: false

  def expected_character("("), do: ")"
  def expected_character("["), do: "]"
  def expected_character("{"), do: "}"
  def expected_character("<"), do: ">"

  def median(list) do
    middle =
      Enum.count(list)
      |> div(2)

    Enum.at(list, middle)
  end
end
