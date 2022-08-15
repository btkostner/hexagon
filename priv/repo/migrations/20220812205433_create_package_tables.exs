defmodule Hexagon.Repo.Migrations.CreatePackageTables do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :description, :string, null: false
      add :external_doc_url, :string
      timestamps()
    end

    create unique_index(:packages, [:name, :type])

    create table(:releases) do
      add :version, :string, null: false
      add :size_in_bytes, :integer, null: false
      add :package_id, references(:packages, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:releases, [:version, :package_id])
  end
end
