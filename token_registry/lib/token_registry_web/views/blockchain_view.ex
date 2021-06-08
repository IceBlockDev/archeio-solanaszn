defmodule TokenRegistryWeb.BlockchainView do
  use TokenRegistryWeb, :view
  alias TokenRegistryWeb.BlockchainView

  def render("index.json", %{blockchains: blockchains}) do
    %{data: render_many(blockchains, BlockchainView, "blockchain.json")}
  end

  def render("show.json", %{blockchain: blockchain}) do
    %{data: render_one(blockchain, BlockchainView, "blockchain.json")}
  end

  def render("blockchain.json", %{blockchain: blockchain}) do
    %{id: blockchain.id,
      name: blockchain.name,
      symbol: blockchain.symbol}
  end
end
