defmodule AdventOfCode.Day02 do
  @input "day_02_input"
         |> Helpers.get_file_content()
         |> Helpers.split_and_parse(",")

  def part1(), do: int_program(replace_noun_and_verb())

  def part2(input), do: find_for_output(input)

  def replace_noun_and_verb(noun \\ 12, verb \\ 2) do
    @input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def int_program(input_list, input \\ "") do
    Enum.reduce_while(
      input_list,
      {input_list, 0},
      fn _elem, {input_list, op_index} ->
        proxy_instruction(input_list, op_index, input)
      end
    )
    |> elem(0)
    |> Enum.join(",")
  end

  def proxy_instruction(input_list, op_index, input) do
    case Enum.at(input_list, op_index) do
      1 ->
        params = parameters(input_list, op_index, 1)
        run_instruction(input_list, params, &Kernel.+/2)

      2 ->
        params = parameters(input_list, op_index, 2)
        run_instruction(input_list, params, &Kernel.*/2)

      3 ->
        output_index = Enum.at(input_list, op_index + 1)
        run_instruction(input_list, op_index, input, output_index)

      4 ->
        run_instruction(input_list, op_index)

      99 ->
        {:halt, {input_list, 0}}
    end
  end

  def parameter_for_mode(input_list, index, :position) do
    position = Enum.at(input_list, index)
    Enum.at(input_list, position)
  end

  def parameter_for_mode(input_list, index, :inmediate) do
    Enum.at(input_list, index)
  end

  def parameter_for_mode(input_list, index, 1), do: Enum.at(input_list, index + 1)

  def parameters(input_list, op_index, opcode) when opcode in [1, 2] do
    {
      [
        parameter_for_mode(input_list, op_index + 1, :position),
        parameter_for_mode(input_list, op_index + 2, :position),
        parameter_for_mode(input_list, op_index + 3, :inmediate)
      ],
      op_index
    }
  end

  def run_instruction(input_list, {[p1, p2, p3], op_index}, op)
      when is_function(op) do
    input_list = List.replace_at(input_list, p3, op.(p1, p2))

    # I guess this will be the next valid opcode
    {:cont, {input_list, op_index + 4}}
  end

  def run_instruction(input_list, op_index, input, output_index) do
    input_list = List.replace_at(input_list, output_index, input)

    # I guess this will be the next valid opcode
    {:cont, {input_list, op_index + 2}}
  end

  def run_instruction(input_list, op_index) do
    # I guess this will be the next valid opcode
    IO.inspect(Enum.at(input_list, op_index + 1))
    {:cont, {input_list, op_index + 2}}
  end

  def find_for_output(expected) do
    try do
      for noun <- 0..99 do
        for verb <- 0..99 do
          output =
            noun
            |> replace_noun_and_verb(verb)
            |> int_program()
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
end
