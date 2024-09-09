defmodule Eventflow.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :capacity, :integer
    field :datetime, :naive_datetime
    field :description, :string
    field :duration, :integer
    field :fee, :decimal, default: 0.0
    field :is_offline, :boolean, default: false
    field :location, :string
    field :published_at, :naive_datetime
    field :rsvp, :boolean, default: false
    field :status, :string
    field :tags, :string
    field :thumbnail, :string
    field :title, :string

    belongs_to :user, Eventflow.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :datetime,
      :duration,
      :status,
      :location,
      :is_offline,
      :capacity,
      :tags,
      :fee,
      :thumbnail,
      :published_at,
      :rsvp,
      :user_id
    ])
    |> validate_required([
      :title,
      :description,
      :datetime,
      :duration,
      :status,
      :location,
      :is_offline,
      :capacity,
      :tags,
      :fee,
      :rsvp,
      :user_id
    ])
  end
end
