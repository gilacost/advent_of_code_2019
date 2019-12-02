defmodule DayTwo do
  @moduledoc """
  # Part one

  An Intcode program is a list of integers separated by commas (like 1,0,0,3,99).
  To run one, start by looking at the first integer (called position 0). Here,
  you will find an opcode - either 1, 2, or 99. The opcode indicates what to do;
  for example, 99 means that the program is finished and should immediately halt.
  Encountering an unknown opcode means something went wrong.

  Once you have a working computer, the first step is to restore the gravity
  assist program (your puzzle input) to the "1202 program alarm" state it had
  just before the last computer caught fire. To do this, before running the
  program, replace position 1 with the value 12 and replace position 2 with the
  value 2.

  # Part two
  With terminology out of the way, we're ready to proceed. To complete the
  gravity assist, you need to determine what pair of inputs produces the output
  19690720.
  """
  @input "day_two_input"
         |> Helpers.get_file_content()
         |> Helpers.split_and_parse(",")

  @doc """
  What value is left at position 0 after the program halts?
  """
  def int_program(noun \\ 12, verb \\ 99) do
    @input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> input_after_anomaly()
  end

  @doc """
  # Examples:
    1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).

    iex> DayTwo.input_after_anomaly([1,0,0,0,99])
    "2,0,0,0,99"

    2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).
    iex> DayTwo.input_after_anomaly([2,3,0,3,99])
    "2,3,0,6,99"

    2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).
    iex> DayTwo.input_after_anomaly([2,4,4,5,99,0 ])
    "2,4,4,5,99,9801"

    1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.
    iex> DayTwo.input_after_anomaly([1,1,1,4,99,5,6,0,99])
    "30,1,1,4,2,5,6,0,99"
  """
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

  @doc """
  Find the input noun and verb that cause the program to produce the output
  19690720. What is 100 * noun + verb? (For example, if noun=12 and verb=2, the
  answer would be 1202.)
  """
  def find_for_output(expected) do
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
            IO.inspect("result: 100 * #{noun} + #{verb}: #{result}")
            throw(:found)

          true ->
            IO.inspect("noun: #{noun} + verb: #{verb} //exepected: #{expected} output: #{output}")
        end
      end
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
