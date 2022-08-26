defmodule Hexagon.Packages do
  @moduledoc """
  The Packages context.
  """

  import Ecto.Query, warn: false

  alias Hexagon.Repo
  alias Hexagon.Packages.{Package, Release}

  @doc """
  Returns the list of packages.

  ## Examples

      iex> list_packages()
      [%Package{}, ...]

      iex> list_packages(order_by: :inserted_at)
      [%Package{}, ...]

  """
  def list_packages(opts \\ []) do
    order_by =
      case Keyword.get(opts, :order_by, :name) do
        :name -> [asc: :name]
        :inserted_at -> [desc: :inserted_at]
      end

    Package
    |> order_by(^order_by)
    |> Repo.all()
  end

  @doc """
  Returns a list of filtered packages via a search query. This is yet to be
  optimized or improved, so right now it's pretty dumb.

  ## Examples

      iex> search_packages("test")
      [%Package{}]

  """
  def search_packages(query) do
    escaped_query = Regex.replace(~r/([\%_])/, query, "\\1")

    Package
    |> where([p], like(p.name, ^"%#{escaped_query}%"))
    |> Repo.all()
  end

  @doc """
  Returns a package by the given id.

  ## Examples

      iex> get_package!(id)
      %Package{}

  """
  def get_package!(id) do
    Repo.get!(Package, id)
  end

  @doc """
  Gets a single package release.

  ## Examples

      iex> get_release(%Package{}, version)
      %Release{}

      iex> get_release(%Package{}, version)
      nil

  """
  def get_release(%Package{id: package_id}, version) do
    Repo.get_by!(Release, package_id: package_id, version: version)
  end

  @doc """
  Creates a new package.

  ## Examples

      iex> create_package(%{field: value})
      {:ok, %Package{}}

      iex> create_package(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_package(attrs \\ %{}) do
    %Package{}
    |> Package.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a package.

  ## Examples

      iex> update_package(package, %{field: new_value})
      {:ok, %Package{}}

      iex> update_package(package, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_package(%Package{} = package, attrs) do
    package
    |> Package.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a package.

  ## Examples

      iex> delete_package(package)
      {:ok, %Package{}}

      iex> delete_package(package)
      {:error, %Ecto.Changeset{}}

  """
  def delete_package(%Package{} = package) do
    # TODO: More
    Repo.delete(package)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking package changes.

  ## Examples

      iex> change_package(package)
      %Ecto.Changeset{data: %Package{}}

  """
  def change_package(%Package{} = package, attrs \\ %{}) do
    Package.update_changeset(package, attrs)
  end

  @doc """
  Loads all associated releases of a package.

  ## Examples

      iex> load_releases(package)
      [%Release{}, ...]

  """
  def load_releases(%Package{} = package) do
    package
    |> Repo.preload(:releases)
    |> Map.update!(:releases, fn releases ->
      Enum.sort_by(releases, & &1.version, {:desc, Version})
    end)
  end

  @doc """
  Creates a new release for a package.

  ## Examples

      iex> create_release(package, 100, %{field: value})
      {:ok, %Release{}}

      iex> create_release(package, 0, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_release(%Package{} = package, size_in_bytes, attrs \\ %{}) do
    %Release{package: package, size_in_bytes: size_in_bytes}
    |> Release.changeset(attrs)
    |> Repo.insert()
  end
end
