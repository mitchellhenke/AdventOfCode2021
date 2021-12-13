defmodule Adventofcode2021.Thirteen do
  @external_resource "data/thirteen.txt"
  @input File.read!("data/thirteen.txt")
         |> String.split("\n\n", trim: true)

  def first do
    [input, folds] = @input

    input =
      String.split(input, "\n")
      |> Enum.map(fn pair ->
        String.split(pair, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    height =
      Enum.map(input, fn [_x, y] ->
        y
      end)
      |> Enum.max()
      |> Kernel.+(1)

    width =
      Enum.map(input, fn [x, _y] ->
        x
      end)
      |> Enum.max()
      |> Kernel.+(1)

    input =
      Enum.reduce(input, %{}, fn [x, y], map ->
        index = y * width + x
        Map.put(map, index, "x")
      end)

    folds =
      String.split(folds, "\n", trim: true)
      |> Enum.map(fn fold ->
        [_, fold] = String.split(fold, "fold along ")
        [axis, number] = String.split(fold, "=")
        {axis, String.to_integer(number)}
      end)

    print_grid({width, height, input}, "initial")

    {_w, _h, map} = apply_fold(input, width, height, hd(folds))

    map_size(map)
  end

  def second do
    [input, folds] = @input

    input =
      String.split(input, "\n")
      |> Enum.map(fn pair ->
        String.split(pair, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    height =
      Enum.map(input, fn [_x, y] ->
        y
      end)
      |> Enum.max()
      |> Kernel.+(1)

    width =
      Enum.map(input, fn [x, _y] ->
        x
      end)
      |> Enum.max()
      |> Kernel.+(1)

    input =
      Enum.reduce(input, %{}, fn [x, y], map ->
        index = y * width + x
        Map.put(map, index, "x")
      end)

    folds =
      String.split(folds, "\n", trim: true)
      |> Enum.map(fn fold ->
        [_, fold] = String.split(fold, "fold along ")
        [axis, number] = String.split(fold, "=")
        {axis, String.to_integer(number)}
      end)

    [input, folds]

    {_w, _h, map} =
      Enum.reduce(folds, {width, height, input}, fn fold, {width, height, map} ->
        apply_fold(map, width, height, fold)
        |> print_grid(fold)
      end)

    map_size(map)
  end

  def apply_fold(map, width, height, {"y", number}) do
    new_height = div(height - 1, 2)

    new_map =
      Enum.reduce(map, %{}, fn {index, value}, new_map ->
        x = rem(index, width)
        y = div(index, width)

        cond do
          y < number ->
            Map.put(new_map, index, value)

          y > number ->
            new_y = abs(y - (y - number) * 2)
            new_index = new_y * width + x
            Map.put(new_map, new_index, value)
        end
      end)

    {width, new_height, new_map}
  end

  def apply_fold(map, width, height, {"x", number}) do
    new_width = div(width - 1, 2)

    new_map =
      Enum.reduce(map, %{}, fn {index, value}, new_map ->
        x = rem(index, width)
        y = div(index, width)

        cond do
          x < number ->
            new_index = y * new_width + x
            Map.put(new_map, new_index, value)

          x > number ->
            new_x = x - (x - number) * 2
            new_index = y * new_width + new_x
            Map.put(new_map, new_index, value)
        end
      end)

    {new_width, height, new_map}
  end

  def print_grid({width, height, map}, fold) do
    IO.inspect("After fold #{inspect(fold)}")
    max_index = width * height - 1

    Enum.map(0..max_index, fn n ->
      Map.get(map, n, ".")
    end)
    |> Enum.chunk_every(width)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()

    {width, height, map}
  end
end
