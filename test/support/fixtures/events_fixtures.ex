defmodule Eventflow.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eventflow.Events` context.
  """
  import Eventflow.UsersFixtures

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, event} =
      attrs
      |> Enum.into(%{
        capacity: 42,
        datetime: ~N[2024-08-01 14:16:00],
        description: "some description",
        duration: 42,
        fee: "0",
        is_offline: true,
        location: "some location",
        published_at: ~N[2024-08-01 14:16:00],
        rsvp: true,
        status: "published",
        tags: "some tags",
        thumbnail: "some thumbnail",
        title: "some title",
        user_id: user.id
      })
      |> Eventflow.Events.create_event()

    event
  end
end
