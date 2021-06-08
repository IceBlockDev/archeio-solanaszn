defmodule TokenRegistry.Registry.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :metadata, :map
    field :name, :string
    field :project_uri, :string
    field :symbol, :string
    field :blockchain_id, :id
    field :icon_upload, :string


    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:name, :symbol, :project_uri, :metadata, :icon_upload])
    |> validate_required([:name, :symbol, :project_uri, :metadata])
    |> unique_constraint(:name)
    |> unique_constraint(:symbol)
  end
end
