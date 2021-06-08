defmodule TokenRegistry.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :name, :string
      add :symbol, :string
      add :project_uri, :string
      add :metadata, :map
      add :blockchain_id, references(:blockchains, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:tokens, [:name])
    create unique_index(:tokens, [:symbol])
    create index(:tokens, [:blockchain_id])
  end
end
