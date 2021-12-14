defmodule Adventofcode2021.Fourteen do
  @external_resource "data/fourteen.txt"
  @input File.read!("data/fourteen.txt")
         |> String.split("\n\n", trim: true)

  def first do
    [template, rules] = @input
    template = String.graphemes(template)

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(fn rule ->
        [pair, character] = String.split(rule, " -> ")
        {String.graphemes(pair), character}
      end)
      |> Enum.into(%{})

    characters =
      Enum.reduce(1..10, template, fn n, template ->
        process_rule(template, rules)
      end)

    frequencies = Enum.frequencies(characters)

    {
      Enum.min_by(frequencies, &elem(&1, 1)),
      Enum.max_by(frequencies, &elem(&1, 1))
    }
  end

  def second do
    [template, rules] = @input

    template =
      String.graphemes(template)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(Map.new(), fn [a, b], map ->
        Map.update(map, [a, b], 1, &(&1 + 1))
      end)

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(fn rule ->
        [pair, character] = String.split(rule, " -> ")
        {String.graphemes(pair), character}
      end)
      |> Enum.into(%{})

    Enum.reduce(1..40, template, fn n, template ->
      process_rule_part_two(template, rules)
    end)
    |> Enum.reduce(%{}, fn {[_a, b], count}, count_map ->
      Map.update(count_map, b, count, &(&1 + count))
    end)
  end

  def process_rule_part_two(template, rules) do
    Map.keys(template)
    |> Enum.filter(&Map.has_key?(rules, &1))
    |> Enum.reduce(template, fn [a, b], new_template ->
      count = Map.get(template, [a, b], 0)
      new_letter = Map.get(rules, [a, b])

      new_template
      |> Map.update([a, new_letter], count, &(&1 + count))
      |> Map.update([new_letter, b], count, &(&1 + count))
      |> Map.update!([a, b], &(&1 - count))
    end)
  end

  def process_rule(template, rules) do
    Enum.chunk_every(template, 2, 1)
    |> Enum.reduce("", fn characters, string ->
      rule = Map.get(rules, characters)

      if rule do
        "#{string}#{hd(characters)}#{rule}"
        |> String.graphemes()
      else
        "#{string}#{hd(characters)}"
        |> String.graphemes()
      end
    end)
  end
end
