defmodule Kreasidev.Repo do
  use Ecto.Repo,
    otp_app: :kreasidev,
    adapter: Ecto.Adapters.Postgres
end
