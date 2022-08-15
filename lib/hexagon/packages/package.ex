defmodule Hexagon.Packages.Package do
  use Ecto.Schema

  import Ecto.Changeset

  @types ~w(hex)

  schema "packages" do
    field :name, :string
    field :type, Ecto.Enum, values: @types
    field :description, :string
    field :external_doc_url, :string

    has_many :releases, Hexagon.Packages.Release
    timestamps()
  end

  @doc false
  def changeset(package, attrs) do
    package
    |> cast(attrs, [:name, :type, :description])
    |> validate_required([:name, :type, :description])
    |> validate_inclusion(:type, @types)
    |> validate_length(:name, min: 2)
    |> validate_format(:name, ~r"^[a-z]\w*$")
    |> unique_constraint([:name, :type])
  end

  def update_changeset(package, attrs) do
    package
    |> cast(attrs, [:description, :external_doc_url])
    |> validate_required([:description])
    |> Hexagon.Extensions.Ecto.Validations.normalize_and_validate_url(:external_doc_url)
  end
end
