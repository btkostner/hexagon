defmodule Hexagon.Authentication do
  @moduledoc """
  The Authentication context. This refers to API tokens and how package
  managers authenticate with the system. If you are looking at how users
  are authenticated with the web UI, see the `Hexagon.Accounts` context.
  """

  import Ecto.Query, warn: false

  alias Hexagon.Repo
  alias Hexagon.Accounts.User
  alias Hexagon.Authentication.Key

  @doc """
  Lists keys for a given subject.

  ## Examples

      iex> list_keys(%User{})
      [%Key{}, ...]

  """
  def list_keys(%User{id: user_id}) do
    Key
    |> where([key], key.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets an authentication key via the token string.

  ## Examples

      iex> get_key("exists")
      %Key{}

      iex> get_key("nil")
      nil

  """
  def get_key(token) do
    Plug.Crypto.secure_compare("", "")

    case Key.verify_query(token) do
      {:ok, query} -> Repo.one(query)
      :error -> nil
    end
  end

  @doc """
  Creates a new authentication key for the subject. This is a shortcut
  for `create_key/1`. See that function for more details.
  """
  def create_key(%User{id: user_id}, attrs) do
    attrs
    |> Map.put("user_id", user_id)
    |> create_key()
  end

  @doc """
  Creates a new authentication key for the subject. Note this returns a three
  tuple on success with the usable token so the user can store it.

  ## Examples

      iex> create_key(%{name: "test", user_id: 123})
      {:ok, %Hexagon.Authentication.Key{}, "abc123"}

      iex> create_key(%{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_key(attrs) do
    {usable_token, hashed_token} = Key.build_hashed_token()
    changeset = Key.changeset(%Key{}, Map.put(attrs, "token", hashed_token))

    case Repo.insert(changeset) do
      {:ok, key} -> {:ok, key, usable_token}
      res -> res
    end
  end

  @doc """
  Updates an existing key. Note, you will only be able to update the
  name field.

  ## Examples

      iex> update_key(%Key{}, %{name: "testing"})
      {:ok, %Key{}}

      iex> update_key(%Key{}, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_key(key, attrs) do
    key
    |> Key.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing a key.

  ## Examples

      iex> change_key(key)
      %Ecto.Changeset{data: %Key{}}

  """
  def change_key(record, attrs \\ %{})
  def change_key(nil, attrs), do: Key.changeset(%Key{}, attrs)
  def change_key(key, attrs), do: Key.update_changeset(key, attrs)
end
