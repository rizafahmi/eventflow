defmodule EventflowWeb.EventRsvpLiveTest do
  use EventflowWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eventflow.{EventsFixtures, UsersFixtures}

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end

  describe "RSVP Page" do
    setup [:create_event]

    test "logged in user can access RSVP page", %{conn: conn, event: event} do
      {:ok, _rsvp_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/events/#{event.id}/rsvp")

      assert html =~ event.title
      assert html =~ "RSVP"
    end

    test "logged in user able to RSVP event", %{conn: conn, event: event} do
      user = user_fixture()

      {:ok, rsvp_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events/#{event.id}/rsvp")

      assert rsvp_live |> element("button", "RSVP") |> render_click() =~
               "Add to calendar"

      rsvps = Eventflow.Commands.list_rsvps(user.id, event.id)
      assert length(rsvps) == 1
      rsvp = List.first(rsvps)
      assert rsvp.user_id == user.id
      assert rsvp.event_id == event.id
    end

    test "if user already RSVPed, show 'Add to calendar' button", %{conn: conn, event: event} do
      # RSVP user to event
      user = user_fixture()
      Eventflow.Commands.create_rsvp(%{user_id: user.id, event_id: event.id})
      # Check for 'Add to calendar' button
      {:ok, _rsvp_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events/#{event.id}/rsvp")

      assert html =~ "Add to calendar"
    end

    # test "if user not RSVP, show RSVP button"
  end
end
