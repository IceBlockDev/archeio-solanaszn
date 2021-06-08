defmodule TokenRegistryWeb.BlockchainLive.Index do
  use TokenRegistryWeb, :live_view

  alias TokenRegistry.Registry
  alias TokenRegistry.Registry.Blockchain

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :blockchains, list_blockchains())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Blockchain")
    |> assign(:blockchain, Registry.get_blockchain!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Blockchain")
    |> assign(:blockchain, %Blockchain{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Blockchains")
    |> assign(:blockchain, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    blockchain = Registry.get_blockchain!(id)
    {:ok, _} = Registry.delete_blockchain(blockchain)

    {:noreply, assign(socket, :blockchains, list_blockchains())}
  end

  defp list_blockchains do
    Registry.list_blockchains()
  end
end
