defmodule UrlShortener.MixProject do
  use Mix.Project

  def project do
    [
      app: :url_shortener,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [ignore_modules: test_coverage_ignore_modules()]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {UrlShortener.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:floki, ">= 0.30.0", only: :test},
      {:heroicons,
       app: false,
       compile: false,
       depth: 1,
       github: "tailwindlabs/heroicons",
       sparse: "optimized",
       tag: "v2.1.1"},
      {:jason, "~> 1.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.2"},
      {:phoenix, "~> 1.7.11"},
      {:postgrex, ">= 0.0.0"},
      {:remote_ip, "~> 1.2"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},

      # Linters
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind url_shortener", "esbuild url_shortener"],
      "assets.deploy": [
        "tailwind url_shortener --minify",
        "esbuild url_shortener --minify",
        "phx.digest"
      ]
    ]
  end

  defp test_coverage_ignore_modules do
    [
      UrlShortener.Application,
      UrlShortener.DataCase,
      UrlShortener.Release,
      UrlShortener.Repo,
      UrlShortenerWeb.ChangesetJSON,
      UrlShortenerWeb.CoreComponents,
      UrlShortenerWeb.Layouts,
      UrlShortenerWeb.Telemetry,
      UrlShortenerWeb.UrlLiveHTML
    ]
  end
end
