# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hexagon.Repo.insert!(%Hexagon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Hexagon.Repo.insert!(%Hexagon.Accounts.User{
  email: "user@example.com",
  password: "password",
  hashed_password: "$2a$12$JsRrZOrs2EeVucYkDUin5.GKwr9ppL4hDLj6ncDGLyFtJRUH.kRl.",
  confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
})
