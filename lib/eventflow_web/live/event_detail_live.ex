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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="card card-compact bg-base-100 w-9/12 shadow-xl">
        <figure>
          <img src={@event.thumbnail} alt={@event.title} class="w-full object-cover" />
        </figure>
        <div class="card-body">
          <article class="prose-base px-8">
            <h2 class="card-title my-0"><%= @event.title %></h2>
            <div id="datetime">
              <span role="img">📅</span> <%= @event.datetime %> (<%= @event.duration %> hour)
            </div>
            <div id="location"><span role="img">📍</span> <%= @event.location %></div>
            <div id="capacity"><span role="img">✌🏼</span> <%= @event.capacity %></div>
            <%= if Decimal.to_integer(@event.fee) > 0 do %>
              <div id="fee"><span role="img">💸</span> <%= @event.fee %></div>
            <% end %>
            <p><%= @event.description %></p>
          </article>
          <div class="card-actions justify-end">
            <.link navigate={~p"/events/#{@event.id}/rsvp"} class="btn btn-primary">RSVP</.link>
            <.link navigate="/" class="btn">Back</.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
