defmodule TokenRegistryWeb.TokenLiveTest do
  use TokenRegistryWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TokenRegistry.Registry

  @create_attrs %{metadata: %{}, name: "some name", project_uri: "some project_uri", symbol: "some symbol"}
  @update_attrs %{metadata: %{}, name: "some updated name", project_uri: "some updated project_uri", symbol: "some updated symbol"}
  @invalid_attrs %{metadata: nil, name: nil, project_uri: nil, symbol: nil}

  defp fixture(:token) do
    {:ok, token} = Registry.create_token(@create_attrs)
    token
  end

  defp create_token(_) do
    token = fixture(:token)
    %{token: token}
  end

  describe "Index" do
    setup [:create_token]

    test "lists all tokens", %{conn: conn, token: token} do
      {:ok, _index_live, html} = live(conn, Routes.token_index_path(conn, :index))

      assert html =~ "Listing Tokens"
      assert html =~ token.name
    end

    test "saves new token", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.token_index_path(conn, :index))

      assert index_live |> element("a", "New Token") |> render_click() =~
               "New Token"

      assert_patch(index_live, Routes.token_index_path(conn, :new))

      assert index_live
             |> form("#token-form", token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#token-form", token: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.token_index_path(conn, :index))

      assert html =~ "Token created successfully"
      assert html =~ "some name"
    end

    test "updates token in listing", %{conn: conn, token: token} do
      {:ok, index_live, _html} = live(conn, Routes.token_index_path(conn, :index))

      assert index_live |> element("#token-#{token.id} a", "Edit") |> render_click() =~
               "Edit Token"

      assert_patch(index_live, Routes.token_index_path(conn, :edit, token))

      assert index_live
             |> form("#token-form", token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#token-form", token: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.token_index_path(conn, :index))

      assert html =~ "Token updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes token in listing", %{conn: conn, token: token} do
      {:ok, index_live, _html} = live(conn, Routes.token_index_path(conn, :index))

      assert index_live |> element("#token-#{token.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#token-#{token.id}")
    end
  end

  describe "Show" do
    setup [:create_token]

    test "displays token", %{conn: conn, token: token} do
      {:ok, _show_live, html} = live(conn, Routes.token_show_path(conn, :show, token))

      assert html =~ "Show Token"
      assert html =~ token.name
    end

    test "updates token within modal", %{conn: conn, token: token} do
      {:ok, show_live, _html} = live(conn, Routes.token_show_path(conn, :show, token))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Token"

      assert_patch(show_live, Routes.token_show_path(conn, :edit, token))

      assert show_live
             |> form("#token-form", token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#token-form", token: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.token_show_path(conn, :show, token))

      assert html =~ "Token updated successfully"
      assert html =~ "some updated name"
    end
  end
end
