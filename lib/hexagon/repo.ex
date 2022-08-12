defmodule Hexagon.Repo do
  use Ecto.Repo,
    otp_app: :hexagon,
    adapter: Ecto.Adapters.SQLite3
end
