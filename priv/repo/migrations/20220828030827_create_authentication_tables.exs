defmodule Hexagon.Repo.Migrations.CreateAuthenticationTables do
  use Ecto.Migration

  def change do
    create table(:authentication_keys) do
      add :name, :string, null: false
      add :token, :binary, null: false, size: 64

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:authentication_keys, [:token])
  end
end
