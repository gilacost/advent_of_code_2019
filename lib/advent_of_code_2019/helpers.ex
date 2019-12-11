defmodule Helpers do
  @moduledoc """
  Centralized helper functions for shared behaviour or actions
  """

  def get_file_content(filename) do
    File.cwd!()
    |> Kernel.<>("/priv/#{filename}")
    |> File.read!()
  end

  def split(string, splitter) do
    String.split(string, splitter)
  end

  def split_and_parse(string, splitter) do
    string
    |> String.split(splitter)
    |> parse_int()
  end

  def parse_int(list) when is_list(list) do
    Enum.map(list, &parse_int(&1))
  end

  def parse_int(string) do
    case Integer.parse(string) do
      {int, ""} -> int
      error -> raise "Integer not parsed, #{inspect(error)}"
    end
  end
end
