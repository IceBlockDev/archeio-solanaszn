defmodule TokenRegistryWeb.TokenListLive do
    use TokenRegistryWeb, :live_component

    alias TokenRegistry.Registry
    alias TokenRegistry.Registry.Token

    @impl true
    def mount(_params, _session, socket) do
      {:ok,
      socket
      |> assign(:page, tokens_page(socket))
      |> assign(query: "", results: %{})
      }
    end

    defp list_tokens(socket) do
      if connected?(socket), do: Registry.paginate_tokens().entries, else: []
    end

    defp tokens_page(socket) do
      if connected?(socket), do: Registry.paginate_tokens().entries, else:  %Scrivener.Page{}
    end

end
