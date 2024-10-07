defmodule Eventflow.Events.Rsvp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events_rsvp" do
    belongs_to :user, Eventflow.Users.User
    belongs_to :event, Eventflow.Events.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rsvp, attrs) do
    rsvp
    |> cast(attrs, [:user_id, :event_id])
    |> validate_required([])
  end
end
