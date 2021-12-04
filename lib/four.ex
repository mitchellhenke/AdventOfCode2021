defmodule Adventofcode2021.Four do
  @external_resource "data/four.txt"
  @input File.read!("data/four.txt")
         |> String.split("\n", trim: true)

  def first do
    [numbers | boards] = @input

    numbers =
      String.split(numbers, ",")
      |> Enum.map(&String.to_integer(&1))

    boards =
      Enum.chunk_every(boards, 5)
      |> Enum.map(fn board ->
        Enum.join(board, " ")
        |> String.split(~r/\s/)
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_integer(&1))
      end)

    Enum.reduce_while(numbers, [[], boards], fn number, [called_numbers, boards] ->
      winner = Enum.find(boards, &winner?(&1, called_numbers))

      if winner do
        difference = MapSet.difference(MapSet.new(winner), MapSet.new(called_numbers))
        answer = Enum.sum(difference) * hd(called_numbers)
        {:halt, answer}
      else
        {:cont, [[number | called_numbers], boards]}
      end
    end)
  end

  def second do
    [numbers | boards] = @input

    numbers =
      String.split(numbers, ",")
      |> Enum.map(&String.to_integer(&1))

    boards =
      Enum.chunk_every(boards, 5)
      |> Enum.map(fn board ->
        Enum.join(board, " ")
        |> String.split(~r/\s/)
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_integer(&1))
      end)

    Enum.reduce_while(numbers, [[], boards, []], fn number,
                                                    [
                                                      called_numbers,
                                                      remaining_boards,
                                                      winning_boards
                                                    ] ->
      winners = Enum.filter(remaining_boards, &winner?(&1, called_numbers))
      remaining = MapSet.difference(MapSet.new(remaining_boards), MapSet.new(winners))

      if MapSet.size(remaining) == 0 do
        [last_winner] = winners
        difference = MapSet.difference(MapSet.new(last_winner), MapSet.new(called_numbers))
        answer = Enum.sum(difference) * hd(called_numbers)
        {:halt, answer}
      else
        {:cont, [[number | called_numbers], remaining, winning_boards ++ winners]}
      end
    end)
  end

  def winner?(board, numbers) do
    rows = Enum.chunk_every(board, 5)

    columns =
      List.zip(rows)
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.chunk_every(5)
      |> hd()

    Enum.any?(rows ++ columns, fn row_or_column ->
      MapSet.subset?(MapSet.new(row_or_column), MapSet.new(numbers))
    end)
  end
end
