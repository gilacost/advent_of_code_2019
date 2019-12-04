defmodule Helpers do
  @moduledoc """
  Centralized helper functions for shared behaviour or actions
  """

  def get_file_content(filename) do
    File.cwd!()
    |> Kernel.<>("/priv/#{filename}")
    |> File.read!()
  end

  def split_and_parse(string, splitter) do
    string
    |> split(splitter)
    |> Enum.map(&parse_int(&1))
  end

  def split(string, splitter) do
    String.split(string, splitter)
  end

  def parse_int(string) do
    case Integer.parse(string) do
      {int, ""} -> int
      _ -> nil
    end
  end

  # def map_many(list, fun_list, opts \\ []) do
  #   fun_list
  #   |> Enum.map(fn fun ->
  #     Enum.map(list, &fun.(&1))
  #   end)
  # end
end
