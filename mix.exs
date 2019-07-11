defmodule GraffitiRemovalRequestFetcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :grr,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: escript_config(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"},
      {:benchee, "~> 1.0", only: :dev},
      # {:floki, "~> 0.21.0"}
    ]
  end

  defp escript_config do
    [main_module: UIClient]
  end
end
