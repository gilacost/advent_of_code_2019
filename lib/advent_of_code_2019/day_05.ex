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
        proxy_instruction(input_list, op_index, input)
      end
    )
    |> elem(0)
    |> Enum.join(",")
  end

  def proxy_instruction(input_list, op_index, input) do
    [modes, opcode] = modes_and_opcode(input_list, op_index)
    # get value of the index is immediate
    case opcode do
      "01" ->
        # operators
        # three params
        {[p1, p2, p3], op_index} = parameters(input_list, modes, op_index)
        input_list = List.replace_at(input_list, p3, p1 + p2)
        {:cont, {input_list, op_index + 4}}

      "02" ->
        # operators
        # three params
        {[p1, p2, p3], op_index} = parameters(input_list, modes, op_index)
        input_list = List.replace_at(input_list, p3, p1 * p2)
        {:cont, {input_list, op_index + 4}}

      "03" ->
        # input
        # one param
        {[p1, _p2, _p3], op_index} = parameters(input_list, modes, op_index)
        input_list = List.replace_at(input_list, p1, input)
        {:cont, {input_list, op_index + 2}}

      "04" ->
        # output
        # one param
        {[p1, _p2, _p3], op_index} = parameters(input_list, modes, op_index)
        IO.inspect(p1, label: "OUTPUT")
        {:cont, {input_list, op_index + 2}}

      "05" ->
        # jump if true
        # two params
        {[p1, p2, _p3], op_index} = parameters(input_list, modes, op_index)
        index = jump_if(true, p1, p2, op_index)
        {:cont, {input_list, index}}

      "06" ->
        # jump if false
        # two params
        {[p1, p2, _p3], op_index} = parameters(input_list, modes, op_index)
        index = jump_if(false, p1, p2, op_index)
        {:cont, {input_list, index}}

      "07" ->
        # less than
        # three params
        {[p1, p2, p3], op_index} = parameters(input_list, modes, op_index)
        value = if p1 < p2, do: 1, else: 0
        input_list = List.replace_at(input_list, p3, value)
        {:cont, {input_list, op_index + 4}}

      "08" ->
        # equal than
        # three params
        {[p1, p2, p3], op_index} = parameters(input_list, modes, op_index)
        value = if p1 == p2, do: 1, else: 0
        input_list = List.replace_at(input_list, p3, value)
        {:cont, {input_list, op_index + 4}}

      "99" ->
        {:halt, {input_list, 0}}

      unkown_opcode ->
        IO.inspect("Something went wrong, Opcode: #{inspect(unkown_opcode)}")
        {:halt, {input_list, 0}}
    end
  end

  def modes_and_opcode(input_list, index) do
    [for_p3, for_p2, for_p1, opcode_1, opcode_2] =
      input_list
      |> Enum.at(index)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.codepoints()

    opcode = "#{opcode_1}#{opcode_2}"

    [
      [for_p3, for_p2, for_p1]
      |> ignore_leading_zeros(opcode),
      opcode
    ]
  end

  def parameters(input_list, [m3, m2, m1], op_index) do
    {
      [
        parameter_for_mode(input_list, op_index + 1, m1),
        parameter_for_mode(input_list, op_index + 2, m2),
        parameter_for_mode(input_list, op_index + 3, m3)
      ],
      op_index
    }
  end

  defp jump_if(true, p1, p2, _index) when p1 != 0, do: p2
  defp jump_if(false, p1, p2, _index) when p1 == 0, do: p2
  defp jump_if(_, _p1, _p2, index), do: index + 3

  def ignore_leading_zeros([_, _, _], "03"),
    do: [:none, :none, :immediate]

  def ignore_leading_zeros([_, for_p2, for_p1], _opcode),
    do: [:immediate, mode(for_p2), mode(for_p1)]

  defp mode("0"), do: :position
  defp mode("1"), do: :immediate

  defp parameter_for_mode(input_list, index, :position) do
    input_list
    |> Enum.at(index, :none)
    |> case do
      :none ->
        :none

      position ->
        Enum.at(input_list, position)
    end
  end

  defp parameter_for_mode(input_list, index, :immediate) do
    Enum.at(input_list, index)
  end

  defp parameter_for_mode(_input_list, _index, :none), do: nil
end
