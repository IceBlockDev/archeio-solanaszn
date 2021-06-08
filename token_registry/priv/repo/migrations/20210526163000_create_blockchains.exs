defmodule TokenRegistry.Repo.Migrations.CreateBlockchains do
  use Ecto.Migration

  def change do
    create table(:blockchains) do
      add :name, :string
      add :symbol, :string

      timestamps()
    end

    create unique_index(:blockchains, [:name])
    create unique_index(:blockchains, [:symbol])
  end
end
