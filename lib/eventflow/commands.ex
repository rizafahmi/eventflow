defmodule Eventflow.Commands do
  @moduledoc """
  Extra functionalities for Event context.
  """

  import Ecto.Query, warn: false
  alias Eventflow.Repo
  alias Eventflow.Events.Rsvp

  @doc """
  Insert data into events_rsvp table.
  """
  def create_rsvp(attrs \\ %{}) do
    %Eventflow.Events.Rsvp{}
    |> Eventflow.Events.Rsvp.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  List data from events_rsvp table.
  """
  def list_rsvps(user_id, event_id) do
    query = from r in Rsvp, where: r.user_id == ^user_id and r.event_id == ^event_id
    Repo.all(query)
  end

  @doc """
  Get rsvp data with given user_id and event_id
  """
  def get_rsvp(user_id, event_id) do
    query = from r in Rsvp, where: r.user_id == ^user_id and r.event_id == ^event_id
    Repo.one(query)
  end
end
