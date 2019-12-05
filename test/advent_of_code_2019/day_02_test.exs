defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  describe "part1" do
    test "1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2)." do
      assert input_after_anomaly([1, 0, 0, 0, 99]) == "2,0,0,0,99"
    end

    test "2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6)" do
      assert input_after_anomaly([2, 3, 0, 3, 99]) == "2,3,0,6,99"
    end

    test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801)." do
      assert input_after_anomaly([2, 4, 4, 5, 99, 0]) == "2,4,4,5,99,9801"
    end

    test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99." do
      assert input_after_anomaly([1, 1, 1, 4, 99, 5, 6, 0, 99]) == "30,1,1,4,2,5,6,0,99"
    end
  end

  describe "part2" do
    test " noun=31 and verb=46, the answer would be 19690720." do
      assert find_for_output(19_690_720) == {31, 46, 3146}
    end
  end
end
