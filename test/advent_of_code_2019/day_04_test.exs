defmodule AdventOfCode2019.Day04Test do
  use ExUnit.Case

  import AdventOfCode2019.Day04

  describe "day four" do
    test "part one" do
      [
        {:valid, 111_111},
        {:decreases, 223_450},
        {:unique_numbers, 123_789}
      ]
      |> Enum.each(fn {_, input} = expected ->
        assert input
               |> Integer.digits()
               |> meets_criteria() == expected
      end)
    end

    test "part two" do
      [
        {:valid, 112_233},
        {:larger_group, 123_444},
        {:valid, 111_122},
        {:valid, 111_233},
        {:valid, 112_345},
        {:larger_group, 333_555}
      ]
      |> Enum.each(fn {_, input} = expected ->
        assert input
               |> Integer.digits()
               |> meets_criteria(true) == expected
      end)
    end
  end
end
