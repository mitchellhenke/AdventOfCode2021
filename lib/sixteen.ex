defmodule Adventofcode2021.Sixteen do
  @external_resource "data/sixteen.txt"
  @input File.read!("data/sixteen.txt")
         |> String.split("\n", trim: true)
         |> hd()

  def first do
    hex = String.to_integer(@input, 16)

    input =
      hex
      |> Integer.to_string(2)
      |> String.graphemes()
      |> Enum.map(&String.to_integer(&1))

    input =
      if Enum.count(input) != String.length(@input) * 4 do
        [0 | input]
      else
        input
      end

    packet = parse(input)
    part1(packet)
  end

  def second do
    hex = String.to_integer(@input, 16)

    input =
      hex
      |> Integer.to_string(2)
      |> String.graphemes()
      |> Enum.map(&String.to_integer(&1))

    input =
      if Enum.count(input) != String.length(@input) * 4 do
        [0 | input]
      else
        input
      end

    packet = parse(input)
    part2(packet)
  end

  # literal
  def parse([version1, version2, version3, 1, 0, 0 | remaining_bits]) do
    version = Integer.undigits([version1, version2, version3], 2)
    digits = parse_literal(remaining_bits)
    remaining = Enum.slice(remaining_bits, (div(length(digits), 4) * 5)..-1)

    %{
      version: version,
      type_id: 4,
      value: Integer.undigits(digits, 2),
      sub_packets: [],
      remaining: remaining
    }
  end

  # parse length_type 0
  def parse([version1, version2, version3, type1, type2, type3, length_type = 0 | remaining_bits]) do
    {bit_length, remaining_bits} = Enum.split(remaining_bits, 15)

    bit_length =
      bit_length
      |> Integer.undigits(2)

    {sub_packets, remaining} = Enum.split(remaining_bits, bit_length)

    %{
      length_type: length_type,
      version: Integer.undigits([version1, version2, version3], 2),
      type_id: Integer.undigits([type1, type2, type3], 2),
      sub_packets: parse_subpackets(sub_packets, []),
      remaining: remaining
    }
  end

  # parse length_type 1
  def parse([version1, version2, version3, type1, type2, type3, length_type = 1 | remaining_bits]) do
    {packet_count, remaining_bits} = Enum.split(remaining_bits, 11)

    packet_count =
      packet_count
      |> Integer.undigits(2)

    {result, remaining} = parse_subpackets(remaining_bits, packet_count, [])

    %{
      length_type: length_type,
      version: Integer.undigits([version1, version2, version3], 2),
      type_id: Integer.undigits([type1, type2, type3], 2),
      sub_packets: result,
      remaining: remaining,
      packet_count: packet_count
    }
  end

  def parse(_) do
    %{
      version: 0,
      type_id: nil,
      sub_packets: []
    }
  end

  def parse_subpackets([], result), do: result

  def parse_subpackets(remaining, result) do
    value = parse(remaining)
    parse_subpackets(Map.get(value, :remaining, []), [value | result])
  end

  def parse_subpackets(remaining, 0, result), do: {result, remaining}

  def parse_subpackets(remaining, count, result) do
    value = parse(remaining)
    parse_subpackets(Map.get(value, :remaining, []), count - 1, [value | result])
  end

  def parse_literal(bits) do
    bits
    |> Enum.chunk_every(5, 5, :discard)
    |> Enum.reduce_while([], fn [bit | four], acc ->
      if bit == 0 do
        {:halt, acc ++ four}
      else
        {:cont, acc ++ four}
      end
    end)
  end

  def part1(packet) do
    if packet.sub_packets do
      Enum.map(packet.sub_packets, &part1(&1))
      |> Enum.sum()
      |> Kernel.+(packet.version)
    else
      packet.version
    end
  end

  def part2(packet) do
    case packet.type_id do
      0 ->
        Enum.map(packet.sub_packets, &part2(&1))
        |> Enum.sum()

      1 ->
        Enum.map(packet.sub_packets, &part2(&1))
        |> Enum.product()

      2 ->
        Enum.map(packet.sub_packets, &part2(&1))
        |> Enum.min()

      3 ->
        Enum.map(packet.sub_packets, &part2(&1))
        |> Enum.max()

      4 ->
        packet.value

      5 ->
        [one, two] = Enum.map(packet.sub_packets, &part2(&1))

        if one < two do
          1
        else
          0
        end

      6 ->
        [one, two] = Enum.map(packet.sub_packets, &part2(&1))

        if one > two do
          1
        else
          0
        end

      7 ->
        [one, two] = Enum.map(packet.sub_packets, &part2(&1))

        if one == two do
          1
        else
          0
        end
    end
  end
end
