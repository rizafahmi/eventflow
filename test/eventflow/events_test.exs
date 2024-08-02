defmodule Eventflow.EventsTest do
  use Eventflow.DataCase

  alias Eventflow.Events

  describe "events" do
    alias Eventflow.Events.Event

    import Eventflow.EventsFixtures

    @invalid_attrs %{
      capacity: nil,
      datetime: nil,
      description: nil,
      duration: nil,
      fee: nil,
      is_offline: nil,
      location: nil,
      published_at: nil,
      rsvp: nil,
      status: nil,
      tags: nil,
      thumbnail: nil,
      title: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
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
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.capacity == 42
      assert event.datetime == ~N[2024-08-01 14:16:00]
      assert event.description == "some description"
      assert event.duration == 42
      assert event.fee == Decimal.new("120.5")
      assert event.is_offline == true
      assert event.location == "some location"
      assert event.published_at == ~N[2024-08-01 14:16:00]
      assert event.rsvp == true
      assert event.status == "some status"
      assert event.tags == "some tags"
      assert event.thumbnail == "some thumbnail"
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        capacity: 43,
        datetime: ~N[2024-08-02 14:16:00],
        description: "some updated description",
        duration: 43,
        fee: "456.7",
        is_offline: false,
        location: "some updated location",
        published_at: ~N[2024-08-02 14:16:00],
        rsvp: false,
        status: "some updated status",
        tags: "some updated tags",
        thumbnail: "some updated thumbnail",
        title: "some updated title"
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.capacity == 43
      assert event.datetime == ~N[2024-08-02 14:16:00]
      assert event.description == "some updated description"
      assert event.duration == 43
      assert event.fee == Decimal.new("456.7")
      assert event.is_offline == false
      assert event.location == "some updated location"
      assert event.published_at == ~N[2024-08-02 14:16:00]
      assert event.rsvp == false
      assert event.status == "some updated status"
      assert event.tags == "some updated tags"
      assert event.thumbnail == "some updated thumbnail"
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
