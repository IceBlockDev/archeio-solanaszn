defmodule TokenRegistryWeb.BlockchainLiveTest do
  use TokenRegistryWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TokenRegistry.Registry

  @create_attrs %{name: "some name", symbol: "some symbol"}
  @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
  @invalid_attrs %{name: nil, symbol: nil}

  defp fixture(:blockchain) do
    {:ok, blockchain} = Registry.create_blockchain(@create_attrs)
    blockchain
  end

  defp create_blockchain(_) do
    blockchain = fixture(:blockchain)
    %{blockchain: blockchain}
  end

  describe "Index" do
    setup [:create_blockchain]

    test "lists all blockchains", %{conn: conn, blockchain: blockchain} do
      {:ok, _index_live, html} = live(conn, Routes.blockchain_index_path(conn, :index))

      assert html =~ "Listing Blockchains"
      assert html =~ blockchain.name
    end

    test "saves new blockchain", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.blockchain_index_path(conn, :index))

      assert index_live |> element("a", "New Blockchain") |> render_click() =~
               "New Blockchain"

      assert_patch(index_live, Routes.blockchain_index_path(conn, :new))

      assert index_live
             |> form("#blockchain-form", blockchain: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#blockchain-form", blockchain: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blockchain_index_path(conn, :index))

      assert html =~ "Blockchain created successfully"
      assert html =~ "some name"
    end

    test "updates blockchain in listing", %{conn: conn, blockchain: blockchain} do
      {:ok, index_live, _html} = live(conn, Routes.blockchain_index_path(conn, :index))

      assert index_live |> element("#blockchain-#{blockchain.id} a", "Edit") |> render_click() =~
               "Edit Blockchain"

      assert_patch(index_live, Routes.blockchain_index_path(conn, :edit, blockchain))

      assert index_live
             |> form("#blockchain-form", blockchain: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#blockchain-form", blockchain: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blockchain_index_path(conn, :index))

      assert html =~ "Blockchain updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes blockchain in listing", %{conn: conn, blockchain: blockchain} do
      {:ok, index_live, _html} = live(conn, Routes.blockchain_index_path(conn, :index))

      assert index_live |> element("#blockchain-#{blockchain.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#blockchain-#{blockchain.id}")
    end
  end

  describe "Show" do
    setup [:create_blockchain]

    test "displays blockchain", %{conn: conn, blockchain: blockchain} do
      {:ok, _show_live, html} = live(conn, Routes.blockchain_show_path(conn, :show, blockchain))

      assert html =~ "Show Blockchain"
      assert html =~ blockchain.name
    end

    test "updates blockchain within modal", %{conn: conn, blockchain: blockchain} do
      {:ok, show_live, _html} = live(conn, Routes.blockchain_show_path(conn, :show, blockchain))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Blockchain"

      assert_patch(show_live, Routes.blockchain_show_path(conn, :edit, blockchain))

      assert show_live
             |> form("#blockchain-form", blockchain: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#blockchain-form", blockchain: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blockchain_show_path(conn, :show, blockchain))

      assert html =~ "Blockchain updated successfully"
      assert html =~ "some updated name"
    end
  end
end
