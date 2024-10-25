defmodule Eventflow.Repo.Migrations.AddSlugToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :slug, :string
    end

  end
end
