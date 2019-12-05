defmodule AdventOfCode.Day01 do
  def part1(fuel_calculator \\ &calculate_fuel/1) do
    "day_01_input"
    |> Helpers.get_file_content()
    |> Helpers.split_and_parse("\n")
    |> Enum.reduce(0, fn mass, acc ->
      fuel_calculator.(mass) + acc
    end)
  end

  def part2() do
    part1(&calculate_fuel_recursively/1)
  end

  def calculate_fuel_recursively(module_mass, acc \\ 0) do
    module_mass
    |> calculate_fuel()
    |> case do
      integer when integer > 0 ->
        calculate_fuel_recursively(integer, acc + integer)

      _ ->
        acc
    end
  end

  def calculate_fuel(module_mass) when is_integer(module_mass) do
    floor(module_mass / 3) - 2
  end

  def calculate_fuel(_module_mass), do: 0
end
