defmodule EventflowWeb.EventLive.Index do
  use EventflowWeb, :live_view

  alias Eventflow.Events
  alias Eventflow.Events.Event

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:poster, accept: ~w(.jpg .jpeg .webp .png), max_entries: 1)

    {:ok, stream(socket, :events, Events.list_events(user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Events.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({EventflowWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Events.get_event!(id)
    {:ok, _} = Events.delete_event(event)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
