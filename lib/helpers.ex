defmodule Helpers do
  @moduledoc """
  Centralized helper functions for shared behaviours or actions
  """

  def get_file_content(filename) do
    File.cwd!()
    |> Kernel.<>("/priv/#{filename}")
    |> File.read!()
  end
end
