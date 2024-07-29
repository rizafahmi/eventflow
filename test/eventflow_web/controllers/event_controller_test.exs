defmodule EventflowWeb.EventControllerTest do
  use EventflowWeb.ConnCase

  import Eventflow.EventsFixtures

  @create_attrs %{capacity: 42, datetime: ~N[2024-07-28 13:40:00], description: "some description", duration: 42, fee: "120.5", is_offline: true, location: "some location", published_at: ~N[2024-07-28 13:40:00], rsvp: true, status: "some status", tags: "some tags", thumbnail: "some thumbnail", title: "some title"}
  @update_attrs %{capacity: 43, datetime: ~N[2024-07-29 13:40:00], description: "some updated description", duration: 43, fee: "456.7", is_offline: false, location: "some updated location", published_at: ~N[2024-07-29 13:40:00], rsvp: false, status: "some updated status", tags: "some updated tags", thumbnail: "some updated thumbnail", title: "some updated title"}
  @invalid_attrs %{capacity: nil, datetime: nil, description: nil, duration: nil, fee: nil, is_offline: nil, location: nil, published_at: nil, rsvp: nil, status: nil, tags: nil, thumbnail: nil, title: nil}

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/events")
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/events/new")
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/events", event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/events/#{id}"

      conn = get(conn, ~p"/events/#{id}")
      assert html_response(conn, 200) =~ "Event #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/events", event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, ~p"/events/#{event}/edit")
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/events/#{event}", event: @update_attrs)
      assert redirected_to(conn) == ~p"/events/#{event}"

      conn = get(conn, ~p"/events/#{event}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/events/#{event}", event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/events/#{event}")
      assert redirected_to(conn) == ~p"/events"

      assert_error_sent 404, fn ->
        get(conn, ~p"/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
