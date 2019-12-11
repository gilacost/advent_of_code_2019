defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  import ExUnit.CaptureIO

  describe "part1" do
    test "1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2)." do
      assert int_program([1, 0, 0, 0, 99]) == "2,0,0,0,99"
    end

    test "2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6)" do
      assert int_program([2, 3, 0, 3, 99]) == "2,3,0,6,99"
    end

    test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801)." do
      assert int_program([2, 4, 4, 5, 99, 0]) == "2,4,4,5,99,9801"
    end

    test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99." do
      assert int_program([1, 1, 1, 4, 99, 5, 6, 0, 99]) == "30,1,1,4,2,5,6,0,99"
    end
  end

  describe "part2" do
    test " noun=31 and verb=46, the answer would be 19690720." do
      assert AdventOfCode.Day02.find_for_output(19_690_720) == {31, 46, 3146}
    end
  end

  describe "part one" do
    test "The program 3,0,4,0,99 outputs whatever it gets as input, then halts" do
      input = Enum.random(0..99)

      assert capture_io(fn ->
               assert int_program([3, 0, 4, 0, 99], input) == "#{input},0,4,0,99"
             end) =~ "OUTPUT: #{input}\n"
    end

    test "Integers can be negative" do
      assert int_program([1101, 100, -1, 4, 0]) == "1101,100,-1,4,99"
    end

    test "with input 1 the output should be OUTPUT: 13210611" do
      assert capture_io(fn ->
               part1()
             end) =~ "OUTPUT: 13210611"
    end
  end

  describe "part two" do
    test "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 will output 0 if the input was zero or 1 if the input was non-zero" do
      assert capture_io(fn ->
               int_program([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], 0)
             end) =~ "OUTPUT: 0\n"

      assert capture_io(fn ->
               int_program([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], 1)
             end) =~ "OUTPUT: 1\n"
    end

    test "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 will output 0 if the input was zero or 1 if the input was non-zero" do
      assert capture_io(fn ->
               int_program([3, 3, 1105, 0, 9, 1101, 0, 0, 12, 4, 12, 99, 1], 0)
             end) =~ "OUTPUT: 0\n"

      assert capture_io(fn ->
               int_program([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1], 1)
             end) =~ "OUTPUT: 1\n"
    end

    test "3,9,8,9,10,9,4,9,99,-1,8 will output 1 if input == 8" do
      assert capture_io(fn ->
               int_program([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 8)
             end) =~ "OUTPUT: 1\n"
    end

    test "3,9,8,9,10,9,4,9,99,-1,8 will output 0 if input != 8" do
      assert capture_io(fn ->
               int_program([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 10)
             end) =~ "OUTPUT: 0\n"
    end

    test "3,9,7,9,10,9,4,9,99,-1,8 will output 1 if input < 8" do
      assert capture_io(fn ->
               int_program([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 7)
             end) == "OUTPUT: 1\n"
    end

    test "3,9,7,9,10,9,4,9,99,-1,8 will output 0 if input >= 8" do
      assert capture_io(fn ->
               int_program([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 8)
             end) == "OUTPUT: 0\n"
    end

    test "3,3,1108,-1,8,3,4,3,99 will output 1 if input == 8" do
      assert capture_io(fn ->
               int_program([3, 3, 1108, -1, 8, 3, 4, 3, 99], 8)
             end) =~ "OUTPUT: 1\n"
    end

    test "3,3,1108,-1,8,3,4,3,99 will output 0 if input != 8" do
      assert capture_io(fn ->
               int_program([3, 3, 1108, -1, 8, 3, 4, 3, 99], 9)
             end) =~ "OUTPUT: 0\n"
    end

    test "3,3,1107,-1,8,3,4,3,99 will output 1 if input < 8" do
      assert capture_io(fn ->
               int_program([3, 3, 1107, -1, 8, 3, 4, 3, 99], 7)
             end) == "OUTPUT: 1\n"
    end

    test "3,3,1107,-1,8,3,4,3,99 will output 0 if input >= 8" do
      assert capture_io(fn ->
               int_program([3, 3, 1107, -1, 8, 3, 4, 3, 99], 8)
             end) == "OUTPUT: 0\n"
    end

    test "large example" do
      program = [
        3,
        21,
        1008,
        21,
        8,
        20,
        1005,
        20,
        22,
        107,
        8,
        21,
        20,
        1006,
        20,
        31,
        1106,
        0,
        36,
        98,
        0,
        0,
        1002,
        21,
        125,
        20,
        4,
        20,
        1105,
        1,
        46,
        104,
        999,
        1105,
        1,
        46,
        1101,
        1000,
        1,
        20,
        4,
        20,
        1105,
        1,
        46,
        98,
        99
      ]

      assert capture_io(fn ->
               int_program(program, 7)
             end) =~ "OUTPUT: 999\n"

      assert capture_io(fn ->
               int_program(program, 8)
             end) == "OUTPUT: 1000\n"

      assert capture_io(fn ->
               int_program(program, 9)
             end) == "OUTPUT: 1001\n"
    end
  end
end
