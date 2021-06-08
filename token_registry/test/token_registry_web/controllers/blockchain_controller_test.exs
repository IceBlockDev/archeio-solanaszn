defmodule TokenRegistryWeb.BlockchainControllerTest do
  use TokenRegistryWeb.ConnCase

  alias TokenRegistry.Registry
  alias TokenRegistry.Registry.Blockchain

  @create_attrs %{
    name: "some name",
    symbol: "some symbol"
  }
  @update_attrs %{
    name: "some updated name",
    symbol: "some updated symbol"
  }
  @invalid_attrs %{name: nil, symbol: nil}

  def fixture(:blockchain) do
    {:ok, blockchain} = Registry.create_blockchain(@create_attrs)
    blockchain
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all blockchains", %{conn: conn} do
      conn = get(conn, Routes.blockchain_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create blockchain" do
    test "renders blockchain when data is valid", %{conn: conn} do
      conn = post(conn, Routes.blockchain_path(conn, :create), blockchain: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.blockchain_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "symbol" => "some symbol"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.blockchain_path(conn, :create), blockchain: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update blockchain" do
    setup [:create_blockchain]

    test "renders blockchain when data is valid", %{conn: conn, blockchain: %Blockchain{id: id} = blockchain} do
      conn = put(conn, Routes.blockchain_path(conn, :update, blockchain), blockchain: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.blockchain_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "symbol" => "some updated symbol"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, blockchain: blockchain} do
      conn = put(conn, Routes.blockchain_path(conn, :update, blockchain), blockchain: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete blockchain" do
    setup [:create_blockchain]

    test "deletes chosen blockchain", %{conn: conn, blockchain: blockchain} do
      conn = delete(conn, Routes.blockchain_path(conn, :delete, blockchain))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.blockchain_path(conn, :show, blockchain))
      end
    end
  end

  defp create_blockchain(_) do
    blockchain = fixture(:blockchain)
    %{blockchain: blockchain}
  end
end
