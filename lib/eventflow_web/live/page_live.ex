defmodule EventflowWeb.PageLive do
  use EventflowWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    events = Eventflow.Events.list_events()

    socket =
      socket
      |> assign(:events, events)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="hero bg-base-200 rounded-xl mb-6">
      <div class="hero-content text-center py-16">
        <div class="max-w-md">
          <h1 class="text-5xl font-bold"><span role="img">📅</span> EventFlow</h1>
          <p class="py-6">Welcome to EventFlow, community-based event management system.</p>
          <button class="btn btn-primary">Check Event</button>
        </div>
      </div>
    </div>
    <h2 class="text-3xl font-bold py-6">Latest Events</h2>
    <div id="events" class="flex flex-wrap gap-5 justify-center">
      <div :for={event <- @events} class="card card-compact bg-base-100 w-96 shadow-xl">
        <figure>
          <img src={event.thumbnail} alt={event.title} />
        </figure>
        <div class="card-body">
          <h2 class="card-title"><%= event.title %></h2>
          <p><%= event.description %></p>
          <div class="card-actions justify-end">
            <a href={~p"/events/#{event.id}"} class="btn btn-primary">Detail</a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
