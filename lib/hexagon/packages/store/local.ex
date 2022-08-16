defmodule Hexagon.Packages.Store.Local do
  @moduledoc """
  A local filesystem control for package management. This links to routes
  for the accompanying `Hexagon.Extensions.Plug.LocalStore`.
  """

  alias Hexagon.Extensions.Plug.LocalStore

  @behaviour Hexagon.Packages.Store

  @impl true
  def get(path) do
    URI.to_string(%URI{
      host: LocalStore.host(),
      port: LocalStore.port(),
      path: path
    })
  end

  @impl true
  def put(path, data) do
    with request <- Finch.build(:put, base_url() <> path, [], data),
         {:ok, %{status: 200}} <- Finch.request(request, Hexagon.FinchPool) do
      :ok
    end
  end

  @impl true
  def delete(path) do
    with request <- Finch.build(:delete, base_url() <> path, []),
         {:ok, %{status: 200}} <- Finch.request(request, Hexagon.FinchPool) do
      :ok
    end
  end

  defp base_url(), do: LocalStore.base_url()
end
