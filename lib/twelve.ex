defmodule Adventofcode2021.Twelve do
  @external_resource "data/twelve.txt"

  @input File.read!("data/twelve.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.split(&1, "-"))

  def first do
    map =
      Enum.reduce(@input, Map.new(), fn [a, b], map ->
        Map.update(map, a, MapSet.new([b]), &MapSet.put(&1, b))
        |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))
      end)

    vertices =
      Map.get(map, "start")
      |> MapSet.to_list()

    find_paths(map, vertices, ["start"], false)
  end

  def second do
    map =
      Enum.reduce(@input, Map.new(), fn [a, b], map ->
        Map.update(map, a, MapSet.new([b]), &MapSet.put(&1, b))
        |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))
      end)

    vertices =
      Map.get(map, "start")
      |> MapSet.to_list()

    find_paths(map, vertices, ["start"], true)
  end

  def find_paths(_map, [], _path, _visit_cave), do: 0

  def find_paths(map, ["start" | rest], path, visit_cave) do
    find_paths(map, rest, path, visit_cave)
  end

  def find_paths(map, ["end" | rest], path, visit_cave) do
    1 + find_paths(map, rest, path, visit_cave)
  end

  def find_paths(map, [vertex | rest], path, visit_cave) do
    lowercase = String.downcase(vertex) == vertex

    paths =
      cond do
        lowercase && !visit_cave && vertex in path ->
          0

        lowercase && visit_cave && vertex in path ->
          vertices =
            Map.get(map, vertex)
            |> MapSet.to_list()

          find_paths(map, vertices, [vertex | path], false)

        true ->
          vertices =
            Map.get(map, vertex)
            |> MapSet.to_list()

          find_paths(map, vertices, [vertex | path], visit_cave)
      end

    paths + find_paths(map, rest, path, visit_cave)
  end
end
