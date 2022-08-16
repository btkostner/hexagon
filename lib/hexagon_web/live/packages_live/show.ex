defmodule HexagonWeb.PackagesLive.Show do
  use HexagonWeb, :live_view

  alias Hexagon.Packages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    package = Packages.get_package!(id)

    {:noreply,
     socket
     |> assign(:page_title, package.name)
     |> assign(:package, package)}
  end
end
