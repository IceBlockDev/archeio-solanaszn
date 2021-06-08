defmodule TokenRegistryWeb.TokenLive.TokenRowComponent do
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

  # @impl true
  # def mount(params, %{"user_token" => user_token} = _session, socket) do
  #   IO.puts "TokenComponent:"
  #   IO.inspect params
  #   {:ok,
  #       socket
  #   # |> assign_user(user_token)
  # }
  # end

  # @impl true
  # def mount(params, _session, socket) do
  #   IO.puts "TokenComponent:"
  #   IO.inspect params
  #   {:ok,
  #     socket
  #   }
  # end

  # defp assign_user(socket, user_token) do

  #   assign_new(socket, :current_user, fn ->
  #     Accounts.get_user_by_session_token(user_token)
  #   end)
  # end

end
