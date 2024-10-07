defmodule Eventflow.Commands do
  @moduledoc """
  Extra functionalities for Event context.
  """

  alias Eventflow.Repo

  @doc """
  Insert data into events_rsvp table.
  """
  def create_rsvp(attrs \\ %{}) do
    %Eventflow.Events.Rsvp{}
    |> Eventflow.Events.Rsvp.changeset(attrs)
    |> Repo.insert()
  end
end
