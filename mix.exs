defmodule AdventOfCode19.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_19,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps, do: []
end
