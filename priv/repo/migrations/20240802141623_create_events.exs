defmodule Eventflow.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :text
      add :datetime, :naive_datetime
      add :duration, :integer
      add :status, :string
      add :location, :string
      add :is_offline, :boolean, default: false, null: false
      add :capacity, :integer
      add :tags, :string
      add :fee, :decimal, default: 0.0
      add :thumbnail, :string
      add :published_at, :naive_datetime
      add :rsvp, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:user_id])
  end
end
