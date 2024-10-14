defmodule Eventflow.RsvpsTest do
  use Eventflow.DataCase

  import Eventflow.{EventsFixtures, UsersFixtures}

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end

  describe "rsvps" do
    setup [:create_user, :create_event]

    test "list_rsvps/0 returns all rsvps for the current event and current user", %{
      user: user,
      event: event
    } do
      Eventflow.Commands.create_rsvp(%{user_id: user.id, event_id: event.id})

      rsvps = Eventflow.Commands.list_rsvps(user.id, event.id)

      assert length(rsvps) == 1
      rsvp = List.first(rsvps)
      assert rsvp.user_id == user.id
      assert rsvp.event_id == event.id
    end

    test "get_rsvp/0 return rsvp for given user and event", %{user: user, event: event} do
      Eventflow.Commands.create_rsvp(%{user_id: user.id, event_id: event.id})
      rsvp = Eventflow.Commands.get_rsvp(user.id, event.id)

      assert rsvp.user_id == user.id
      assert rsvp.event_id == event.id
    end

    test "get_rsvp/0 return nil if data not exist" do
      rsvp = Eventflow.Commands.get_rsvp(25, 43)

      assert rsvp == nil
    end
  end
end
