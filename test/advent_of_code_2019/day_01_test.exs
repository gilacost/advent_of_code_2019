defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  describe "part1" do
    test "For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2." do
      assert calculate_fuel(12) == 2
    end

    test "For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel is still 2." do
      assert calculate_fuel(14) == 2
    end

    test "For a mass of 1969, the fuel required is 654." do
      assert calculate_fuel(1969) == 654
    end

    test "For a mass of 100756, the fuel required is 33583." do
      assert calculate_fuel(100_756) == 33583
    end
  end

  describe "part2" do
    test "Recursive fuel calculation." do
      assert calculate_fuel_recursively(14) == 2

      assert calculate_fuel_recursively(1969) == 966

      assert calculate_fuel_recursively(100_756) == 50346
    end
  end
end
