defmodule TokenRegistry.Registry.Blockchain do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blockchains" do
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(blockchain, attrs) do
    blockchain
    |> cast(attrs, [:name, :symbol])
    |> validate_required([:name, :symbol])
    |> unique_constraint(:name)
    |> unique_constraint(:symbol)
  end
end
