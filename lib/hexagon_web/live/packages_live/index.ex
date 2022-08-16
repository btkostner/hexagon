defmodule HexagonWeb.PackagesLive.Index do
  use HexagonWeb, :live_view

  alias Hexagon.Packages
  alias Hexagon.Packages.Package

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :packages, list_packages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Packages")
    |> assign(:package, nil)
  end

  defp list_packages do
    Packages.list_packages()
  end
end
