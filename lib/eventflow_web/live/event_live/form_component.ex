defmodule EventflowWeb.EventLive.FormComponent do
  use EventflowWeb, :live_component

  alias Eventflow.Events

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:datetime]} type="datetime-local" label="Datetime" />
        <.input field={@form[:duration]} type="number" label="Duration" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:is_offline]} type="checkbox" label="Is offline" />
        <.input field={@form[:capacity]} type="number" label="Capacity" />
        <.input field={@form[:tags]} type="text" label="Tags" />
        <.input field={@form[:fee]} type="number" label="Fee" step="any" />
        <label for="event_thumbnail" class="block text-sm font-semibold leading-6 text-zinc-800">
          Thumbnail
        </label>
        <%= if @form[:thumbnail].value do %>
          <img src={@form[:thumbnail].value} alt="Thumbnail" class="w-32" />
        <% end %>
        <.live_file_input upload={@uploads.poster} />
        <%= for entry <- @uploads.poster.entries do %>
          <article class="upload-entry">
            <figure>
              <.live_img_preview entry={entry} />
            </figure>
            <button phx-click="cancel-upload" phx-value-ref={entry.ref}>
              Cancel
            </button>
          </article>
        <% end %>
        <.input field={@form[:published_at]} type="datetime-local" label="Published at" />
        <.input field={@form[:rsvp]} type="checkbox" label="Rsvp" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:form, fn ->
        to_form(Events.change_event(event))
      end)
      |> assign(:uploaded_files, [])
      |> allow_upload(:poster, accept: ~w(.jpg .jpeg .webp .png), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Events.change_event(socket.assigns.event, event_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    case socket.assigns.event.user_id do
      nil ->
        ^event_params =
          event_params
          |> Map.put("user_id", socket.assigns.current_user.id)

      _ ->
        event_params
    end

    uploaded_files =
      consume_uploaded_entries(socket, :poster, fn %{path: path}, entry ->
        dest =
          Path.join(
            Application.app_dir(:eventflow, "priv/static/uploads"),
            Path.basename(entry.client_name)
          )

        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    socket =
      socket
      |> update(:uploaded_files, &(&1 ++ uploaded_files))

    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    params =
      case List.first(socket.assigns.uploaded_files) do
        nil -> event_params
        thumbnail -> Map.put(event_params, "thumbnail", thumbnail)
      end

    case Events.update_event(socket.assigns.event, params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_event(socket, :new, event_params) do
    params = Map.put(event_params, "thumbnail", hd(socket.assigns.uploaded_files))

    case Events.create_event(params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
