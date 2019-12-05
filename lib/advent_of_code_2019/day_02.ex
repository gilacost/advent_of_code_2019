defmodule AdventOfCode.Day02 do
  @input "day_02_input"
         |> Helpers.get_file_content()
         |> Helpers.split_and_parse(",")

  def part1(), do: int_program()

  def part2(input), do: find_for_output(input)

  def int_program(noun \\ 12, verb \\ 2) do
    @input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> input_after_anomaly()
  end

  def input_after_anomaly(input_list) do
    Enum.reduce_while(
      input_list,
      {input_list, 0},
      fn _elem, {input_list, op_index} ->
        if op_index == 0 || rem(op_index, 4) == 0 do
          case Enum.at(input_list, op_index) do
            1 ->
              run_instruction(input_list, op_index, &Kernel.+/2)

            2 ->
              run_instruction(input_list, op_index, &Kernel.*/2)

            99 ->
              {:halt, {input_list, 0}}
          end
        else
          {:cont, {input_list, op_index + 1}}
        end
      end
    )
    |> elem(0)
    |> Enum.join(",")
  end

  def find_for_output(expected) do
    try do
      for noun <- 0..99 do
        for verb <- 0..99 do
          output =
            noun
            |> int_program(verb)
            |> String.split(",")
            |> Enum.at(0)
            |> Integer.parse()
            |> elem(0)

          cond do
            output > expected ->
              throw(:bigger)

            expected == output ->
              result = 100 * noun + verb
              throw({:found, noun, verb, result})

            true ->
              nil
          end
        end
      end
    catch
      {:found, noun, verb, result} -> {noun, verb, result}
    end
  end

  def run_instruction(input_list, op_index, op) do
    first_input_index = Enum.at(input_list, op_index + 1)
    second_input_index = Enum.at(input_list, op_index + 2)
    output_index = Enum.at(input_list, op_index + 3)

    input_list =
      List.replace_at(
        input_list,
        output_index,
        op.(
          Enum.at(input_list, first_input_index),
          Enum.at(input_list, second_input_index)
        )
      )

    {:cont, {input_list, op_index + 1}}
  end
end
