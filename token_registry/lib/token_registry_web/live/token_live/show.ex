defmodule TokenRegistryWeb.TokenLive.Show do
  use TokenRegistryWeb, :live_view

  alias TokenRegistry.Registry

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:token, Registry.get_token!(id))}
  end

  defp page_title(:show), do: "Show Token"
  defp page_title(:edit), do: "Edit Token"
end
