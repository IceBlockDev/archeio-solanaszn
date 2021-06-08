defmodule TokenRegistryWeb.TokenLive.TokenChartComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry


  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_chart
    }
  end


  defp assign_chart(%{assigns: %{token: token}} = socket) do
    data = [{1, 1}, {2, 2}]
    ds = Contex.Dataset.new(data, ["x", "y"])
    point_plot = Contex.PointPlot.new(ds)
    plot = Contex.Plot.new(600, 400, point_plot)
    socket
    |> assign(:chart, plot  |> Contex.Plot.to_svg)
  end



end
