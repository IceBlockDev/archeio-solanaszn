defmodule TokenRegistryWeb.TokenLive.Index do
  use TokenRegistryWeb, :live_view

  alias TokenRegistry.Registry
  alias TokenRegistry.Registry.Token

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:sort, "symbol.asc")
    |> assign(:pager, tokens_pager(socket, %{
      "sort" => "symbol.asc",
      "page" => "1",
    }))
    |> assign(query: "", results: %{})
    }
  end

  @impl true
  def handle_params(%{"sort" => sort, "page" => page} = params, url, socket) do
    IO.inspect({params, url, socket})
    {:noreply,
    apply_action(socket, socket.assigns.live_action, params)
    |> assign(:pager, tokens_pager(socket, params))
    }
  end
  @impl true
  def handle_params(_, url, socket) do
   handle_params(%{"sort" => "symbol.asc", "page" => "1"}, url, socket )
  end

  @impl true
  def handle_event("search", %{"search" => query}, socket) do
    {:noreply, assign(socket, :tokens, list_search(query))}
  end




  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Token")
    |> assign(:token, Registry.get_token!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Token")
    |> assign(:token, %Token{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tokens")
    |> assign(:token, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    token = Registry.get_token!(id)
    {:ok, _} = Registry.delete_token(token)

    {:noreply, assign(socket, :tokens, list_tokens())}
  end

  defp list_tokens do
    Registry.list_tokens()
  end

  defp list_search( query) do
    Registry.search_tokens(query)
  end

  defp tokens_pager(socket, params) do
    if connected?(socket), do: Registry.paginate_tokens(params), else:  %Scrivener.Page{
      entries: [],
      page_number:  1,
      page_size: 0,
      total_entries: 0,
      total_pages:  0
    }
  end

  # def handle_params(params, _, socket) do
  #   IO.inspect({"handle_params", params})
  #   {:noreply,
  #    socket
  #   |> assign(:pager, tokens_pager(socket, params))
  #   }
  # end

  # def handle_params(_, _, socket) do
  #   IO.inspect({"handle_params", "_,_"})
  #   {:noreply, socket}
  # end

  def handle_event("nav", %{"page" => page} = params, socket) do
    IO.inspect({"nav", params, socket})

    {:noreply,
        socket
        |> assign(:page, page)
        |> push_patch( to: Routes.token_index_path(socket, :index, sort: socket.assigns.sort, page: page))
      }
  end

  def handle_event("sort", %{"sort" => sort} = params, socket) do
    socket =
      socket
      |> assign(:sort, sort)
      IO.inspect({"sort", params, socket})
    {:noreply,
      push_patch(socket, to: Routes.token_index_path(socket, :index, sort: sort, page: socket.assigns.page))
  }

  end



  # def handle_event("nav", params, socket) do

  #   {:noreply, live_redirect(socket, to: Routes.live_path(socket, ProductListLive, page: page))}

  #   pager = tokens_pager(socket, params)
  #   IO.inspect(pager)

  #   {:noreply,
  #   socket
  #   |> assign(:pager, pager)
  #   }

  #   # {:noreply, live_redirect(socket, to: Routes.live_path(socket, Index, page_number: page_number))}
  # end

end
