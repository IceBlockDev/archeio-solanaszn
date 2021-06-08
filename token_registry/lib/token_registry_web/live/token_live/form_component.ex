defmodule TokenRegistryWeb.TokenLive.FormComponent do
  use TokenRegistryWeb, :live_component

  alias TokenRegistry.Registry




  @impl true
  def update(%{token: token} = assigns, socket) do
    changeset = Registry.change_token(token)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image,
              accept: ~w(.jpg .jpeg .png), max_entries: 1,
              auto_upload: true, progress: &handle_progress/3
              )
    }
  end

@impl Phoenix.LiveView
def handle_event("validate", _params, socket) do
  {:noreply, socket}
end


  # @impl true
  # def handle_event("validate", %{"token" => token_params}, socket) do
  #   changeset =
  #     socket.assigns.token
  #     |> Registry.change_token(token_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  def handle_event("save", %{"token" => token_params}, socket) do
    save_token(socket, socket.assigns.action, token_params)
  end

  defp save_token(socket, :edit, token_params ) do
    case Registry.update_token(socket.assigns.token, (process_token_params(token_params))) do
      {:ok, _token} ->
        {:noreply,
         socket
         |> put_flash(:info, "Token updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_token(socket, :new, token_params) do
    case Registry.create_token(process_token_params(token_params)) do
      {:ok, _token} ->
        {:noreply,
         socket
         |> put_flash(:info, "Token created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp process_token_params(%{"metadata" => metadata} = token_params) do
    token_params |> Map.put("metadata", Jason.decode!(metadata))
  end

  defp handle_progress(:image, entry, socket) do
      if entry.done? do
        path =
        consume_uploaded_entry(
          socket,entry,
          &upload_static_file(&1, socket)
        )
        {:noreply,
        socket
        |> put_flash(:info, "file #{entry.client_name} uploaded")
        |> update_changeset(:icon_upload, path)}
        else
          {:noreply, socket}
      end
    end

    def update_changeset(%{assigns: %{changeset: changeset}} = socket, key, value) do
      socket
      |> assign(:changeset, Ecto.Changeset.put_change(changeset, key, value))
    end

    defp upload_static_file(%{path: path}, socket) do
      # Plug in your production image file persistence implementation here!
      dest = Path.join("priv/static/images", Path.basename(path))
      File.cp!(path, dest)
      Routes.static_path(socket, "/images/#{Path.basename(dest)}")
    end

end
