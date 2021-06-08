defmodule TokenRegistryWeb.TokenLive.TokenBasicComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry


  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_sparkline()}
  end


  defp assign_sparkline(%{assigns: %{token: token}} = socket) do
    socket
    |> assign(:chart, Contex.Sparkline.new([0, 5, 10, 15, 12, 12, 15, 14, 20, 14, 10, 15, 15]) |> Contex.Sparkline.draw() )
  end



end
