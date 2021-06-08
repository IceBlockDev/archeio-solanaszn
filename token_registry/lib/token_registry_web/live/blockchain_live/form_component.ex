defmodule TokenRegistryWeb.BlockchainLive.FormComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry

  @impl true
  def update(%{blockchain: blockchain} = assigns, socket) do
    changeset = Registry.change_blockchain(blockchain)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"blockchain" => blockchain_params}, socket) do
    changeset =
      socket.assigns.blockchain
      |> Registry.change_blockchain(blockchain_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"blockchain" => blockchain_params}, socket) do
    save_blockchain(socket, socket.assigns.action, blockchain_params)
  end

  defp save_blockchain(socket, :edit, blockchain_params) do
    case Registry.update_blockchain(socket.assigns.blockchain, blockchain_params) do
      {:ok, _blockchain} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blockchain updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_blockchain(socket, :new, blockchain_params) do
    case Registry.create_blockchain(blockchain_params) do
      {:ok, _blockchain} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blockchain created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
