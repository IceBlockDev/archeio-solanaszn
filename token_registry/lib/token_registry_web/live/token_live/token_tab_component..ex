defmodule TokenRegistryWeb.TokenLive.TokenTabComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry


  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end


end
