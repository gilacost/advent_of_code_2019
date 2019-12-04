defmodule AdventOfCode2019DocTest do
  use ExUnit.Case
  doctest DayOne
  doctest DayTwo

  test "closest intersection example " do
    [
      {"R8,U5,L5,D3\nU7,R6,D4,L4", 6},
      {"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 159},
      {"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 135}
    ]
    |> Enum.each(fn {input, expected} ->
      assert input
             |> Helpers.split("\n")
             |> Enum.map(&Helpers.split(&1, ","))
             |> DayThree.closest_intersection() == expected
    end)
  end

  test "shortest path to intersection examples " do
    [
      {"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 410},
      {"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 610}
    ]
    |> Enum.each(fn {input, expected} ->
      assert input
             |> Helpers.split("\n")
             |> Enum.map(&Helpers.split(&1, ","))
             |> DayThree.shortest_path_to_intersection() == expected
    end)
  end
end
