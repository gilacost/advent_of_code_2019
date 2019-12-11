defmodule AdventOfCode.Day05 do
  @input "day_05_input"
         |> Helpers.get_file_content()
         |> Helpers.split_and_parse(",")
         |> Enum.reject(&is_nil/1)

  def part1(input \\ 1), do: int_program(@input, input)

  def part2(input \\ 5), do: int_program(@input, input)

  def int_program(input_list, input \\ "") do
    Enum.reduce_while(
      input_list,
      {input_list, 0},
      fn _elem, {input_list, op_index} ->
        input_list
        |> modes_and_opcode(op_index)
        |> proxy_instruction(input_list, op_index, input)
      end
    )
    |> elem(0)
    |> Enum.join(",")
  end

  def modes_and_opcode(input_list, index) do
    [for_p2, for_p1, opcode_1, opcode_2] =
      input_list
      |> Enum.at(index)
      |> Integer.to_string()
      |> String.pad_leading(4, "0")
      |> String.codepoints()

    opcode = "#{opcode_1}#{opcode_2}"

    [
      [:immediate, mode(for_p2), mode(for_p1)],
      opcode
    ]
  end

  def proxy_instruction([[m3, m2, m1], "01"], input_list, op_index, _input) do
    # operators
    # three params
    [p1, p2, p3] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2),
      parameter_for_mode(input_list, op_index + 3, m3)
    ]

    input_list = List.replace_at(input_list, p3, p1 + p2)
    {:cont, {input_list, op_index + 4}}
  end

  def proxy_instruction([[m3, m2, m1], "02"], input_list, op_index, _input) do
    # operators
    # three params
    #
    [p1, p2, p3] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2),
      parameter_for_mode(input_list, op_index + 3, m3)
    ]

    input_list = List.replace_at(input_list, p3, p1 * p2)
    {:cont, {input_list, op_index + 4}}
  end

  def proxy_instruction([_, "03"], input_list, op_index, input) do
    # input
    # one param
    p1 = parameter_for_mode(input_list, op_index + 1, :immediate)
    input_list = List.replace_at(input_list, p1, input)
    {:cont, {input_list, op_index + 2}}
  end

  def proxy_instruction([[_m3, _m2, m1], "04"], input_list, op_index, _input) do
    # output
    # one param
    p1 = parameter_for_mode(input_list, op_index + 1, m1)
    IO.inspect(p1, label: "OUTPUT")
    {:cont, {input_list, op_index + 2}}
  end

  def proxy_instruction([[_m3, m2, m1], "05"], input_list, op_index, _input) do
    # jump if true
    # two params
    [p1, p2] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2)
    ]

    index = jump_if(true, p1, p2, op_index)
    {:cont, {input_list, index}}
  end

  def proxy_instruction([[_m3, m2, m1], "06"], input_list, op_index, _input) do
    # jump if false
    # two params
    [p1, p2] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2)
    ]

    index = jump_if(false, p1, p2, op_index)
    {:cont, {input_list, index}}
  end

  def proxy_instruction([[m3, m2, m1], "07"], input_list, op_index, _input) do
    # less than
    # three params
    #
    [p1, p2, p3] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2),
      parameter_for_mode(input_list, op_index + 3, m3)
    ]

    value = if p1 < p2, do: 1, else: 0
    input_list = List.replace_at(input_list, p3, value)
    {:cont, {input_list, op_index + 4}}
  end

  def proxy_instruction([[m3, m2, m1], "08"], input_list, op_index, _input) do
    # equal than
    # three params
    #
    [p1, p2, p3] = [
      parameter_for_mode(input_list, op_index + 1, m1),
      parameter_for_mode(input_list, op_index + 2, m2),
      parameter_for_mode(input_list, op_index + 3, m3)
    ]

    value = if p1 == p2, do: 1, else: 0
    input_list = List.replace_at(input_list, p3, value)
    {:cont, {input_list, op_index + 4}}
  end

  def proxy_instruction([_modes, "99"], input_list, _op_index, _input) do
    {:halt, {input_list, 0}}
  end

  def proxy_instruction([_modes, unknown_opcode], input_list, _op_index, _input) do
    IO.inspect("Something went wrong, Opcode: #{inspect(unknown_opcode)}")
    {:halt, {input_list, 0}}
  end

  defp jump_if(true, p1, p2, _index) when p1 != 0, do: p2
  defp jump_if(false, p1, p2, _index) when p1 == 0, do: p2
  defp jump_if(_, _p1, _p2, index), do: index + 3

  defp mode("0"), do: :position
  defp mode("1"), do: :immediate

  defp parameter_for_mode(input_list, index, :position) do
    position = Enum.at(input_list, index)
    Enum.at(input_list, position)
  end

  defp parameter_for_mode(input_list, index, :immediate) do
    Enum.at(input_list, index)
  end
end
