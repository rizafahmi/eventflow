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
    field :slug, :string, default: ""

    field :status, Ecto.Enum,
      values: [:draft, :pre_event, :on_event, :finished_event, :published],
      default: :pre_event

    field :tags, :string
    field :thumbnail, :string
    field :title, :string

    belongs_to :user, Eventflow.Users.User
    many_to_many :users, Eventflow.Users.User, join_through: Eventflow.Events.Rsvp

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
      :slug,
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
    |> validate_length(:description, min: 10, max: 4000)
    |> generate_slug()
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :title) do
      nil ->
        changeset

      title ->
        dbg(title)

        put_change(
          changeset,
          :slug,
          String.downcase(title) |> String.slice(0, 15) |> String.replace(~r/\s+/, "-")
        )
    end
  end
end
