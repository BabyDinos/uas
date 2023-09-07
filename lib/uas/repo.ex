defmodule Uas.Repo do
  use Ecto.Repo,
    otp_app: :uas,
    adapter: Ecto.Adapters.Postgres
end
