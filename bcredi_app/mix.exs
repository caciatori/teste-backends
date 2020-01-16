defmodule BcrediApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :bcredi_app,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {BcrediApp.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1"}
    ]
  end
end
