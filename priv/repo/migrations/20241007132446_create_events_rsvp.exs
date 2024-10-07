defmodule Eventflow.Repo.Migrations.CreateEventsRsvp do
  use Ecto.Migration

  def change do
    create table(:events_rsvp) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:events_rsvp, [:user_id])
    create index(:events_rsvp, [:event_id])
  end
end
