defmodule Hexagon.Authentication.Key do
  use Ecto.Schema

  import Ecto.{Changeset, Query}

  @hash_algorithm :sha256
  @rand_size 64

  schema "authentication_keys" do
    field :name, :string
    field :token, :binary, redact: true

    belongs_to :user, Hexagon.Accounts.User

    timestamps()
  end

  @doc """
  Creates an `Ecto.Changeset` for `#{__MODULE__}`. This requires you to specify a
  hashed token when you create a record. To do this, see the
  `build_hashed_token/0` method.
  """
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:name, :user_id, :token])
    |> validate_name()
    |> validate_required([:user_id, :token])
  end

  @doc """
  Creates an `Ecto.Changeset` for updating an already existing `#{__MODULE__}`.
  """
  def update_changeset(token, attrs) do
    token
    |> cast(attrs, [:name])
    |> validate_name()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, max: 255)
  end

  @doc """
  Builds a token and a hashed version of that token.

  The non-hashed token is sent to the end user to be stored how they want. The
  hashed part is stored in the database. The original token cannot be reconstructed,
  which means anyone with read-only access to the database cannot directly use
  the token in the application to gain access.
  """
  @spec build_hashed_token() :: {binary(), binary()}
  def build_hashed_token() do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false), hashed_token}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the `#{__MODULE__}` found by the token, if any.

  The given token is valid if it matches its hashed counterpart in the
  database.
  """
  def verify_query(token) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from key in __MODULE__,
            join: user in assoc(key, :user),
            where: key.token == ^hashed_token,
            preload: [user: user]

        {:ok, query}

      :error ->
        :error
    end
  end
end
