defmodule Jobber.MixProject do
  use Mix.Project

  def project do
    [
      app: :jobber,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Jobber.Application, []}
    ]
  end

  defp deps do
    []
  end
end
