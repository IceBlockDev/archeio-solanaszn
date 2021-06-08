defmodule TokenRegistryWeb.TokenController do
  use TokenRegistryWeb, :controller

  alias TokenRegistry.Registry
  alias TokenRegistry.Registry.Token

  action_fallback TokenRegistryWeb.FallbackController

  def index(conn, _params) do
    tokens = Registry.list_tokens()
    render(conn, "index.json", tokens: tokens)
  end

  def create(conn, %{"token" => token_params}) do
    with {:ok, %Token{} = token} <- Registry.create_token(token_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.token_path(conn, :show, token))
      |> render("show.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    token = Registry.get_token!(id)
    render(conn, "show.json", token: token)
  end

  def update(conn, %{"id" => id, "token" => token_params}) do
    token = Registry.get_token!(id)

    with {:ok, %Token{} = token} <- Registry.update_token(token, token_params) do
      render(conn, "show.json", token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = Registry.get_token!(id)

    with {:ok, %Token{}} <- Registry.delete_token(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
