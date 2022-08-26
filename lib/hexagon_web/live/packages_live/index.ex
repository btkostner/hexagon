defmodule HexagonWeb.PackagesLive.Index do
  use HexagonWeb, :live_view

  alias Hexagon.Packages

  @query_defaults %{
    "sort" => "name",
    "search" => ""
  }
  @query_options ~w(search sort)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    safe_params = Map.take(params, @query_options)

    params =
      @query_defaults
      |> Map.merge(safe_params)
      |> Map.to_list()
      |> Enum.sort_by(fn {k, _v} ->
        Enum.find_index(@query_options, &(&1 === k))
      end)
      |> Enum.reverse()

    socket = Enum.reduce(params, socket, &handle_query_value/2)

    {:noreply, socket}
  end

  @impl true
  def handle_event("sort", %{"value" => sort}, socket) do
    route =
      Routes.packages_index_path(socket, :index, %{search: socket.assigns.search, sort: sort})

    {:noreply, push_patch(socket, to: route, replace: true)}
  end

  defp handle_query_value({"sort", "date_created"}, socket),
    do: assign(socket, :sort, :inserted_at)

  defp handle_query_value({"sort", _}, socket), do: assign(socket, :sort, :name)

  defp handle_query_value({"search", str}, socket) when str != "" do
    socket
    |> assign(:page_title, "Searching")
    |> assign(:packages, Packages.search_packages(str))
    |> assign(:search, str)
  end

  defp handle_query_value({"search", _}, socket) do
    socket
    |> assign(:page_title, "Packages")
    |> assign(:packages, Packages.list_packages(order_by: socket.assigns.sort))
    |> assign(:search, "")
  end
end
