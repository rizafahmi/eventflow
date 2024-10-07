defmodule EventflowWeb.EventRsvpLive do
  use EventflowWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    event = Eventflow.Events.get_event!(params["event_id"])

    socket =
      socket
      |> assign(:event, event)
      |> assign(:status, :rsvping)

    {:ok, socket}
  end

  @impl true
  def handle_event("rsvp", %{"event_id" => event_id}, socket) do
    params = %{
      event_id: event_id,
      user_id: socket.assigns.current_user.id
    }

    case Eventflow.Commands.create_rsvp(params) do
      {:ok, rsvp} ->
        socket =
          socket
          |> put_flash(:info, "Thanks for your RSVP!")
          |> update(:status, fn _ -> :rsvped end)

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Cannot RSVP. Try again.")

        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="card bg-base-100 image-full w-9/12 shadow-xl">
        <figure class="blur-sm">
          <img src={@event.thumbnail} alt={@event.title} class="w-full object-cover" />
        </figure>
        <div class="card-body">
          <h2 class="card-title"><%= @event.title %></h2>
          <div id="datetime">
            <span role="img">📅</span> <%= @event.datetime %> (<%= @event.duration %> hour)
          </div>
          <div id="location"><span role="img">📍</span> <%= @event.location %></div>
          <div id="capacity"><span role="img">✌🏼</span> <%= @event.capacity %></div>
          <%= if Decimal.to_integer(@event.fee) > 0 do %>
            <div id="fee"><span role="img">💸</span> <%= @event.fee %></div>
          <% end %>
          <div class="card-actions justify-end">
            <%= if @status == :rsvped do %>
              <button class="btn btn-neutral">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="icon icon-tabler icons-tabler-outline icon-tabler-calendar"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M4 7a2 2 0 0 1 2 -2h12a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2v-12z" /><path d="M16 3v4" /><path d="M8 3v4" /><path d="M4 11h16" /><path d="M11 15h1" /><path d="M12 15v3" />
                </svg>
                Add to calendar
              </button>
              <button class="btn btn-neutral">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="icon icon-tabler icons-tabler-outline icon-tabler-share"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M6 12m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0" /><path d="M18 6m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0" /><path d="M18 18m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0" /><path d="M8.7 10.7l6.6 -3.4" /><path d="M8.7 13.3l6.6 3.4" />
                </svg>
                Share
              </button>
            <% else %>
              <button phx-click="rsvp" phx-value-event_id={@event.id} class="btn btn-primary">
                RSVP
              </button>
              <.link navigate={~p"/events/#{@event.id}"} class="btn btn-ghost">
                No, I changed my mind
              </.link>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
