defmodule TokenRegistryWeb.BlockchainController do
  use TokenRegistryWeb, :controller

  alias TokenRegistry.Registry
  alias TokenRegistry.Registry.Blockchain

  action_fallback TokenRegistryWeb.FallbackController

  def index(conn, _params) do
    blockchains = Registry.list_blockchains()
    render(conn, "index.json", blockchains: blockchains)
  end

  def create(conn, %{"blockchain" => blockchain_params}) do
    with {:ok, %Blockchain{} = blockchain} <- Registry.create_blockchain(blockchain_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.blockchain_path(conn, :show, blockchain))
      |> render("show.json", blockchain: blockchain)
    end
  end

  def show(conn, %{"id" => id}) do
    blockchain = Registry.get_blockchain!(id)
    render(conn, "show.json", blockchain: blockchain)
  end

  def update(conn, %{"id" => id, "blockchain" => blockchain_params}) do
    blockchain = Registry.get_blockchain!(id)

    with {:ok, %Blockchain{} = blockchain} <- Registry.update_blockchain(blockchain, blockchain_params) do
      render(conn, "show.json", blockchain: blockchain)
    end
  end

  def delete(conn, %{"id" => id}) do
    blockchain = Registry.get_blockchain!(id)

    with {:ok, %Blockchain{}} <- Registry.delete_blockchain(blockchain) do
      send_resp(conn, :no_content, "")
    end
  end
end
