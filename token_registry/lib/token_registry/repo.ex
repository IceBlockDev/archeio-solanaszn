defmodule TokenRegistry.Repo do
  use Ecto.Repo,
    otp_app: :token_registry,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 25
end
