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

test_package_one =
  Hexagon.Repo.insert!(%Hexagon.Packages.Package{
    name: "test_package_one",
    type: :hex,
    description: "A database seeded test package",
    external_doc_url: "https://example.com"
  })

Hexagon.Repo.insert!(%Hexagon.Packages.Release{
  version: "0.0.1",
  size_in_bytes: 100,
  package_id: test_package_one.id
})

Hexagon.Repo.insert!(%Hexagon.Packages.Release{
  version: "0.0.2",
  size_in_bytes: 200,
  package_id: test_package_one.id
})

Hexagon.Repo.insert!(%Hexagon.Packages.Release{
  version: "0.0.3",
  size_in_bytes: 300,
  package_id: test_package_one.id
})

Hexagon.Repo.insert!(%Hexagon.Packages.Release{
  version: "0.4.0",
  size_in_bytes: 400,
  package_id: test_package_one.id
})

Hexagon.Repo.insert!(%Hexagon.Packages.Release{
  version: "5.0.0",
  size_in_bytes: 500,
  package_id: test_package_one.id
})

Hexagon.Repo.insert!(%Hexagon.Packages.Package{
  name: "new_test_package",
  type: :hex,
  description: "A new test package with no releases"
})
