defmodule DayFour do
  @input "278384-824795"
         |> Helpers.split_and_parse("-")

  def password_possibilities(one_double? \\ false, input_list \\ @input),
    do: password_possibilities_list(one_double?, input_list) |> length

  def password_possibilities_list(one_double?, input_list) do
    [bottom, top] = input_list

    Enum.reduce(bottom..top, [], fn number, valid_passwords ->
      digit_list = Integer.digits(number)

      case meets_criteria(digit_list, one_double?) do
        {:valid, _d} ->
          List.insert_at(valid_passwords, -1, number)

        _ ->
          valid_passwords
      end
    end)
  end

  def meets_criteria(digit_list, one_double? \\ false) do
    {state, digit_list} =
      with 6 <- length(digit_list),
           true <- has_repeated_numbers(digit_list),
           {:valid, digit_list} <- is_never_decreased(digit_list),
           false <- one_double? do
        {:valid, digit_list}
      else
        {error, digit_list} ->
          {error, digit_list}

        true ->
          digit_groups = group_by_digit(digit_list)

          if at_least_one_double(digit_groups) do
            {:valid, digit_list}
          else
            {:larger_group, digit_list}
          end

        false ->
          {:unique_numbers, digit_list}

        _ ->
          {:unknown, digit_list}
      end

    {state, Integer.undigits(digit_list)}
  end

  def group_by_digit(digit_list) do
    digit_list
    |> Enum.map(&to_string/1)
    |> Enum.group_by(& &1)
  end

  def at_least_one_double(digit_groups) do
    group_list_count =
      digit_groups
      |> Map.values()
      |> Enum.map(&length(&1))

    Enum.count(group_list_count, fn x -> x == 2 end) > 0
  end

  def has_repeated_numbers(digit_list) do
    length(digit_list) !=
      digit_list
      |> Enum.uniq()
      |> length
  end

  def is_never_decreased(digit_list) do
    digit_list
    |> Enum.reduce_while(0, fn x, n ->
      if x <= Enum.at(digit_list, n + 1) do
        {:cont, n + 1}
      else
        {:halt, n}
      end
    end)
    |> case do
      n when n < 5 ->
        {:decreases, digit_list}

      _ ->
        {:valid, digit_list}
    end
  end

  def join_digits(digit_list), do: Integer.undigits(digit_list)
end
