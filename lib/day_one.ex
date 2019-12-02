defmodule DayOne do
  @moduledoc """
  # Part one

  Fuel required to launch a given module is based on its mass. Specifically, to
  find the fuel required for a module, take its mass, divide by three, round
  down, and subtract 2.

  # Part two

  So, for each module mass, calculate its fuel and add it to the total. Then,
  treat the fuel amount you just calculated as the input mass and repeat the
  process, continuing until a fuel requirement is zero or negative.
  """

  @doc """
  What is the sum of the fuel requirements for all of the modules on your
  spacecraft?
  """

  def calculate_total_fuel(fuel_calculator \\ &DayOne.calculate_fuel/1) do
    "day_one_input"
    |> Helpers.get_file_content()
    |> Helpers.split_and_parse("\n")
    |> Enum.reduce(0, fn mass, acc ->
      fuel_calculator.(mass) + acc
    end)
  end

  @doc """
  # Examples:

  - A module of mass 14 requires 2 fuel. This fuel requires no further fuel
  (2 divided by 3 and rounded down is 0, which would call for a negative fuel),
  so the total fuel required is still just 2.
  iex> DayOne.calculate_fuel_recursively(14)
  2

  - At first, a module of mass 1969 requires 654 fuel. Then, this fuel requires
  216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which requires 21
  fuel, which requires 5 fuel, which requires no further fuel. So, the total
  fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966.
  iex> DayOne.calculate_fuel_recursively(1969)
  966

  - The fuel required by a module of mass 100756 and its fuel is: 33583 + 11192 +
  3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.
  iex> DayOne.calculate_fuel_recursively(100756)
  50346


  """
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

  @doc """
  # Examples:

  For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get
  2.
  iex> DayOne.calculate_fuel(12)
  2

  For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel
  required is also 2.
  iex> DayOne.calculate_fuel(14)
  2

  For a mass of 1969, the fuel required is 654.
  iex> DayOne.calculate_fuel(1969)
  654

  For a mass of 100756, the fuel required is 33583.
  iex> DayOne.calculate_fuel(100756)
  33583
  """
  def calculate_fuel(module_mass) when is_integer(module_mass) do
    floor(module_mass / 3) - 2
  end

  def calculate_fuel(_module_mass), do: 0
end
