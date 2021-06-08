defmodule TokenRegistryWeb.TokenLive.TokenTableComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry


  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:metadata, get_metadata)
    }
  end


  def column(socket, header, field) do
    IO.inspect({socket, header, field})
    header
  end

  def get_metadata() do
    response = HTTPoison.get! "http://ec2-3-87-173-80.compute-1.amazonaws.com:9999/token-values"
    response.body |> Jason.decode! |> Enum.map(fn x -> {x["mintAddress"], x} end) |> Map.new
  end




end
