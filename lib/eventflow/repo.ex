defmodule Eventflow.Repo do
  use Ecto.Repo,
    otp_app: :eventflow,
    adapter: Ecto.Adapters.SQLite3
end
