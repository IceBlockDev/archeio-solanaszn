defmodule TokenRegistryWeb.TokenLive.TokenTickerComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry


  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:price, 239.90)
     |> assign(:pchg, 2.90)
     |> assign(:volume, 34000)
     |> assign(:hi, 261.90)
     |> assign(:lo, 222.90)
     |> assign_sparkline()
    }
  end


  defp assign_sparkline(%{assigns: %{token: token}} = socket) do
    socket
    |> assign(:sparkline, Contex.Sparkline.new([0, 5, 10, 15, 12, 12, 15, 14, 20, 14, 10, 15, 15]) |> Contex.Sparkline.draw() )
  end



end
