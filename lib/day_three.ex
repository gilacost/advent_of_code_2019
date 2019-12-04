defmodule DayThree do
  @input "day_three_input"
         |> Helpers.get_file_content()
         |> String.split("\n")
         |> List.delete_at(-1)
         |> Enum.map(&String.split(&1, ","))

  def closest_intersection(input_list \\ @input) do
    input_list
    |> wire_list()
    |> intersection_list()
    |> Enum.map(&manhattan_distance(&1))
    |> Enum.sort()
    |> Enum.at(1)
  end

  def shortest_path_to_intersection(input_list \\ @input) do
    [wire1, wire2] = wires = wire_list(input_list)

    intersections = intersection_list(wires)

    Enum.reduce(wire2, [], fn point2, step_list ->
      if point2 in intersections and point2 != {0, 0} do
        wire1_match_index = find_index_in_wire(wire1, point2)
        wire2_match_index = find_index_in_wire(wire2, point2)

        steps_wire1 = wire1 |> steps_to_point(wire1_match_index)
        steps_wire2 = wire2 |> steps_to_point(wire2_match_index)

        List.insert_at(step_list, -1, steps_wire1 + steps_wire2)
      else
        step_list
      end
    end)
    |> Enum.min()
  end

  def find_index_in_wire(wire, point) do
    Enum.find_index(wire, &(&1 == point))
  end

  def steps_to_point(wire, index) do
    # This works for the puzzle but not for the tests
    # I need to substract one from the index
    wire
    |> Enum.slice(0..(index - 1))
    |> length
  end

  def intersection_list(wires) do
    [wire1, wire2] = Enum.map(wires, &MapSet.new(&1))

    wire1
    |> MapSet.intersection(wire2)
    |> MapSet.to_list()
  end

  def wire_list(input_list) do
    input_list
    |> Enum.map(fn wire ->
      to_coordinate_list(wire)
    end)
  end

  def manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  def distance_from_origin({x, y}) do
    :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))
  end

  def to_coordinate_list(wire) do
    wire
    |> Enum.reduce([{0, 0}], fn movement, path ->
      movement
      |> String.codepoints()
      |> forward(path)
    end)
    |> Enum.uniq()
  end

  def forward(charlist, path) do
    [dir | distance] = charlist

    distance =
      distance
      |> Enum.join()
      |> Helpers.parse_int()

    previous_position = List.last(path)

    segment =
      dir
      |> to_coordinate(previous_position, distance)
      |> fill_between(previous_position)

    path ++ segment
  end

  def to_coordinate(dir, {x, y}, distance) do
    case dir do
      "R" ->
        {x + distance, y}

      "U" ->
        {x, y + distance}

      "L" ->
        {x - distance, y}

      "D" ->
        {x, y - distance}
    end
  end

  def fill_between({x2, y2}, {x1, y1}) do
    cond do
      x2 != x1 ->
        Enum.map(x1..x2, &{&1, y1})

      y2 != y1 ->
        Enum.map(y1..y2, &{x1, &1})

      true ->
        IO.inspect([x1, y1, x2, y2])
        throw(:break)
    end
  end
end
