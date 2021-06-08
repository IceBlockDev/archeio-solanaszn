defmodule TokenRegistry.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      TokenRegistry.Repo,
      # Start the Telemetry supervisor
      TokenRegistryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TokenRegistry.PubSub},
      # Start the Endpoint (http/https)
      TokenRegistryWeb.Endpoint,
      TokenRegistry.Scheduler,
      # worker(:bigchaindb_port, [], restart: :permanent, shutdown: 5000, function: :start),
      # {Mongo, [name: :mongo, database: "bigchain", url: "mongodb://bchaindb:27017/bigchain", pool_size: 10]},
      # Start a worker by calling: TokenRegistry.Worker.start_link(arg)
      # {TokenRegistry.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TokenRegistry.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TokenRegistryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
