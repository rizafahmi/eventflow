defmodule EventflowWeb.EventDetailLive do
  use EventflowWeb, :live_view

  @impl true
  def mount(%{"event_id" => event_id}, _session, socket) do
    event = Eventflow.Events.get_event!(String.to_integer(event_id))

    socket =
      socket
      |> assign(:event, event)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="event-detail" class="flex flex-col gap-6">
      <div id="poster" class="">
        <figure>
          <img src={@event.thumbnail} alt={@event.title} />
        </figure>
      </div>
      <div id="title" class="">
        <h2 class="text-3xl font-bold"><%= @event.title %></h2>
        <div id="datetime">
          <span role="img">📅</span> <%= @event.datetime %> (<%= @event.duration %> hour)
        </div>
        <div id="location"><span role="img">📍</span> <%= @event.location %></div>
        <div id="capacity"><span role="img">✌🏼</span> <%= @event.capacity %></div>
        <%= if Decimal.to_integer(@event.fee) > 0 do %>
          <div id="fee"><span role="img">💸</span> <%= @event.fee %></div>
        <% end %>
        <p><%= @event.description %></p>
      </div>
      <div id="actions" class="">
        <.link navigate={~p"/events/#{@event.id}/rsvp"} class="btn btn-primary">RSVP</.link>
        <.link navigate="/" class="btn">Back</.link>
      </div>
    </div>
    """
  end
end
