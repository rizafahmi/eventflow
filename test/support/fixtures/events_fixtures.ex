defmodule Eventflow.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eventflow.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        capacity: 42,
        datetime: ~N[2024-08-01 14:16:00],
        description: "some description",
        duration: 42,
        fee: "120.5",
        is_offline: true,
        location: "some location",
        published_at: ~N[2024-08-01 14:16:00],
        rsvp: true,
        status: "some status",
        tags: "some tags",
        thumbnail: "some thumbnail",
        title: "some title"
      })
      |> Eventflow.Events.create_event()

    event
  end
end
