defmodule Hexagon.Packages.Package do
  use Ecto.Schema

  import Ecto.Changeset

  @types ~w(hex)a

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
    |> validate_required([:name, :type])
    |> validate_inclusion(:type, @types)
    |> validate_length(:name, min: 2, max: 200)
    |> validate_format(:name, ~r/^[a-z]\w*$/)
    |> unique_constraint([:name, :type])
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def update_changeset(package, attrs) do
    package
    |> cast(attrs, [:description, :external_doc_url])
    |> Hexagon.Extensions.Ecto.Validations.normalize_and_validate_url(:external_doc_url)
  end
end
