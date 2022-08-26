defmodule Hexagon.Packages.Store do
  @moduledoc """
  Filesystem control for package management. This module passes basic get, put,
  and delete functions to the configurable backend. By default this is a
  backend that stores files locally.
  """

  @doc """
  Returns full authenticated URI for a package. This will be sent to the
  end user package manager.
  """
  @callback get(Path.t()) :: {:ok, String.t()} | {:error, any()}

  @doc """
  Saves a file in the package store.
  """
  @callback put(Path.t(), binary()) :: :ok | {:error, any()}

  @doc """
  Deletes an existing file in the store. A no-op if the file does not exist.
  """
  @callback delete(Path.t()) :: :ok | {:error, any()}

  @doc """
  Returns a fully URL to download a package. This can be a normal URL, or in
  most cases, will be an authenticated URL behind some S3 like bucket.
  """
  @spec get(Path.t()) :: {:ok, String.t()} | {:error, any()}
  def get(path), do: api().get(path)

  @doc """
  Saves a file in the package store.
  """
  @spec put(Path.t(), binary()) :: :ok | {:error, any()}
  def put(path, data), do: api().put(path, data)

  @doc """
  Deletes a file in the package store. If the file does not exist, it's
  considered a no-op.
  """
  @spec delete(Path.t()) :: :ok | {:error, any()}
  def delete(path), do: api().delete(path)

  defp api(), do: Keyword.get(config(), :module)
  defp config(), do: Application.get_env(:hexagon, :packages_store)
end
