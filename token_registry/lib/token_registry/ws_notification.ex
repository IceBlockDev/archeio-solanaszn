defmodule TokenRegistry.WsNotification do
  require Logger

  def demo() do
    Logger.debug("Demo notification")
    TokenRegistryWeb.Endpoint.broadcast!("notification:all", "epoch", %{data: "lalal", number: 1})
  end

end
