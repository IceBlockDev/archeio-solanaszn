defmodule TokenRegistryWeb.NotificationChannel do
  use TokenRegistryWeb, :channel
  require Logger


  def join("notification:" <> nroom, params, socket) do
    Logger.debug("TRWNC join #{nroom}")
    {:ok, socket}
  end

  def handle_in(cmd, payload, socket) do
    Logger.debug("TRWNC IN: #{inspect(cmd)}  -- #{inspect(payload)}")
    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    Logger.debug("====================== HI ====== #{inspect(msg)}")
    {:noreply, socket}
  end

#  def handle_out(event, msg, socket) do
#    Logger.debug("====================== HI ====== #{inspect(msg)}")
#
#  end

end
