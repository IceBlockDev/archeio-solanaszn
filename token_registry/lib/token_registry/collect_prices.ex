defmodule TokenRegistry.CollectPrices do
  alias TokenRegistry.Registry
  def collect() do
    # response = HTTPoison.get! "http://ec2-3-87-173-80.compute-1.amazonaws.com:9999/token-values"
    # m = response.body |> Jason.decode! |> Enum.map(fn x -> {x["mintAddress"], x} end) |> Map.new
    # Registry.list_tokens  |> Enum.map(fn t -> update_token(Map.get(m, t.metadata["mintAddress"]))  end)
  end

  def update_token(token, metadata) do
    # Map.token.metadata  = metadata
    # Registry.update_token(token)
  end


end
