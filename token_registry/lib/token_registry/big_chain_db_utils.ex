defmodule TokenRegistry.BigChainDbUtils do

  def get_db_uri() do
    "http://bchaindb:9984"
  end

  def info() do
    response = HTTPoison.get!(get_db_uri())
    Jason.decode!(response.body)
  end


  def get_transaction(tid) do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/transactions/#{tid}")
    Jason.decode!(response.body)
  end

  def get_transactions(asset_id, operation \\ nil, last_tx \\ nil) do
    path = get_db_uri() <> "/api/v1/transactions?asset_id=#{asset_id}"
    path = case operation do
      nil -> path
      _   -> path <> "&operation=#{operation}"
    end
    path = case last_tx do
      nil -> path
      _   -> path <> "&last_tx=#{last_tx}"
    end
    response = HTTPoison.get!(path) 
    Jason.decode!(response.body)
  end

  def get_assets(pattern, limit \\ 0) do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/assets/?search=#{pattern}&limit=#{limit}")
    Jason.decode!(response.body)
  end

  def get_metadata(pattern, limit \\ 0) do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/metadata/?search=#{pattern}&limit=#{limit}")
    Jason.decode!(response.body)
  end

  def get_transaction_list(limit, skip) do
    #{:ok, conn} = Mongo.start_link(url: "mongodb://bchaindb:27017/bigchain")
    #cur = Mongo.find(conn, "transactions", %{}, [limit: limit, skip: skip, sort: %{id: 1}])
    cur = Mongo.find(:mongo, "transactions", %{}, [limit: limit, skip: skip, sort: %{id: 1}])
    cur |> Enum.to_list()
  end

  def get_validators() do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/validators")
    Jason.decode!(response.body)
  end

  def get_block(block_height) do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/blocks/#{block_height}")
    Jason.decode!(response.body)
  end

  def get_transaction_blocks(transaction_id) do
    response = HTTPoison.get!(get_db_uri() <> "/api/v1/blocks?transaction_id=#{transaction_id}")
    Jason.decode!(response.body)
  end

"""
  # usage example:
  TokenRegistry.BigChainDbUtils.create_transaction(%{
    "public_key"  => "BCjpjCCW1DVsNH2jFqc1v3BFozM6AFSPVPyMFVv5P58F",
    "private_key" => "23Wk3JchELr4yxEA59ar2zrUzArViQ9FRLNhdKg42E2g",
    "metadata" => %{"key" => "value1"},
    "asset" => %{"key1" => "v1", "key2" => "v2"}
  })
"""

  def create_transaction(tdata, mode \\ "async") do
    arg = Jason.encode!(Map.take(tdata, ["public_key", "private_key", "asset", "metadata"]))
    ret = :bigchaindb_port.cmd(:transactioncreate, [:erlang.binary_to_list(arg)])
    Jason.decode!(ret)
  end

"""
  # usage example:
  TokenRegistry.BigChainDbUtils.update_transaction(%{
    "txid" => "b56cb577c244930be2fad04ff0b33939b30c079519109409603d78ddf65bea5a",
    "recipient_public_key"  => "BCjpjCCW1DVsNH2jFqc1v3BFozM6AFSPVPyMFVv5P58F",
    "owner_private_key" => "23Wk3JchELr4yxEA59ar2zrUzArViQ9FRLNhdKg42E2g",
    "metadata" => %{"key" => "value2"}
  })
"""

  def update_transaction(tdata) do
    arg = Jason.encode!(Map.take(tdata, ["txid", "metadata", "recipient_public_key", "owner_private_key"]))
    ret = :bigchaindb_port.cmd(:transactionupdate, [:erlang.binary_to_list(arg)])
    Jason.decode!(ret)
  end





end
