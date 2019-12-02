defmodule Helpers do
  @moduledoc """
  Centralized helper functions for shared behaviours or actions
  """

  def get_file_content(filename) do
    File.cwd!()
    |> Kernel.<>("/priv/#{filename}")
    |> File.read!()
  end

  def split_and_parse(string, splitter) do
    string
    |> String.split(splitter)
    |> Enum.map(fn str ->
      case Integer.parse(str) do
        {int, ""} -> int
        _ -> nil
      end
    end)
  end
end
