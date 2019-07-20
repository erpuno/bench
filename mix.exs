defmodule Bench.MixProject do
  use Mix.Project

  def project do
    [
      app: :bench,
      version: "0.7.0",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    """
    BENCH performance tool for distributed systems
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Georgi Spasov", "Maxim Sokhatsky"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/o7/bench"}
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Bench.Application, []}, applications: [:gun, :n2o]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21.1", only: :dev, runtime: false},
      {:gun, "~> 1.3.0"},
      {:n2o, "~> 6.7.4"}
    ]
  end
end
