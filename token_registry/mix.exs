defmodule TokenRegistry.MixProject do
  use Mix.Project

  def project do
    [
      app: :token_registry,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :erlang] ++ Mix.compilers,
      start_permanent: Mix.env() == :prod,
      erlc_options: erlc_options(Mix.env),
      erlc_paths: ["lib/token_registry/ports"],
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp erlc_options(:test), do: [{:d, :TEST}] ++ erlc_options(:prod)
  #defp erlc_options(_), do: [:debug_info, {:parse_transform, :lager_transform}]
  defp erlc_options(_), do: [:debug_info]

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TokenRegistry.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.0"},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.15.7"},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:quantum, "~> 3.0"},
      #{:basefiftyeight, "~> 0.1.0"},
      {:earmark, "~> 1.4"},
      {:phx_gen_auth, "~> 0.7", only: [:dev], runtime: false},
      {:mongodb, "~> 0.5.1"},
      {:decimal, "~> 2.0", override: true},
      {:contex, "0.3.0"},
      {:scrivener_ecto, "~> 2.0"},
      # {:lit, "~> 0.1.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
