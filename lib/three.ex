defmodule Adventofcode2021.Three do
  @external_resource "data/three.txt"
  @readings File.read!("data/three.txt")
            |> String.split("\n", trim: true)

  def first do
    columns =
      Enum.map(@readings, fn reading ->
        String.graphemes(reading)
      end)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)

    gamma =
      Enum.map(columns, fn column ->
        zero_count = Enum.count(column, &(&1 == "0"))
        one_count = Enum.count(column, &(&1 == "1"))

        if zero_count > one_count do
          "0"
        else
          "1"
        end
      end)
      |> Enum.join()

    integer_gamma = String.to_integer(gamma, 2)

    integer_epsilon =
      invert(gamma)
      |> String.to_integer(2)

    IO.inspect(integer_gamma, label: "Gamma")
    IO.inspect(integer_epsilon, label: "Epsilon")

    integer_gamma * integer_epsilon
  end

  def second do
    oxygen =
      find_oxygen(@readings, 0)
      |> String.to_integer(2)

    co2 =
      find_co2(@readings, 0)
      |> String.to_integer(2)

    IO.inspect(oxygen, label: "Oxygen")
    IO.inspect(co2, label: "CO2")

    oxygen * co2
  end

  defp find_oxygen([final], _index), do: final

  defp find_oxygen(remaining, index) do
    characters_at_index =
      Enum.map(remaining, fn rating ->
        String.graphemes(rating)
        |> Enum.at(index)
      end)

    case most_frequent_element(characters_at_index) do
      "0" ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "0"
        end)

      "1" ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "1"
        end)

      :eq ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "1"
        end)
    end
    |> find_oxygen(index + 1)
  end

  defp find_co2([final], _index), do: final

  defp find_co2(remaining, index) do
    characters_at_index =
      Enum.map(remaining, fn rating ->
        String.graphemes(rating)
        |> Enum.at(index)
      end)

    case least_frequent_element(characters_at_index) do
      "0" ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "0"
        end)

      "1" ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "1"
        end)

      :eq ->
        Enum.filter(remaining, fn x ->
          element =
            String.graphemes(x)
            |> Enum.at(index)

          element == "0"
        end)
    end
    |> find_co2(index + 1)
  end

  defp most_frequent_element(list) do
    frequencies = Enum.frequencies(list)

    cond do
      Map.get(frequencies, "0") > Map.get(frequencies, "1") ->
        "0"

      Map.get(frequencies, "0") < Map.get(frequencies, "1") ->
        "1"

      true ->
        :eq
    end
  end

  defp least_frequent_element(list) do
    frequencies = Enum.frequencies(list)

    cond do
      Map.get(frequencies, "0") < Map.get(frequencies, "1") ->
        "0"

      Map.get(frequencies, "0") > Map.get(frequencies, "1") ->
        "1"

      true ->
        :eq
    end
  end

  defp invert(binary_string) do
    String.graphemes(binary_string)
    |> Enum.map(fn character ->
      cond do
        character == "1" ->
          "0"

        character == "0" ->
          "1"
      end
    end)
    |> Enum.join()
  end
end
