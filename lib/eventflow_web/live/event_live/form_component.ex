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
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:datetime]} type="datetime-local" label="Datetime" />
        <.input field={@form[:duration]} type="number" label="Duration" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:is_offline]} type="checkbox" label="Is offline" />
        <.input field={@form[:capacity]} type="number" label="Capacity" />
        <.input field={@form[:tags]} type="text" label="Tags" />
        <.input field={@form[:fee]} type="number" label="Fee" step="any" />
        <.input field={@form[:thumbnail]} type="text" label="Thumbnail" />
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
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Events.change_event(event))
     end)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Events.change_event(socket.assigns.event, event_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    params =
      event_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    save_event(socket, socket.assigns.action, params)
  end

  defp save_event(socket, :edit, event_params) do
    case Events.update_event(socket.assigns.event, event_params) do
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
    case Events.create_event(event_params) do
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
