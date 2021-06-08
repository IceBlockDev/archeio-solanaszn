defmodule TokenRegistry.Repo.Migrations.AddIconToToken do
  use Ecto.Migration

  def change do
    alter table(:tokens) do
      add :icon_upload, :string end
  end
end
