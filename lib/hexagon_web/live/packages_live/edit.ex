defmodule HexagonWeb.PackagesLive.Edit do
  use HexagonWeb, :live_view

  alias Hexagon.Packages
  alias Hexagon.Packages.Package

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    package = Packages.get_package!(id)

    socket
    |> assign(:page_title, "Edit Package")
    |> assign(:package, package)
    |> assign(:changeset, Packages.change_package(package))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Package")
    |> assign(:package, %Package{})
    |> assign(:changeset, Packages.change_package(%Package{}))
  end

  @impl true
  def handle_event("validate", %{"package" => package_params}, socket) do
    changeset =
      socket.assigns.package
      |> Packages.change_package(package_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("delete", _params, socket) do
    {:ok, _package} = Packages.delete_package(socket.assigns.package)

    {:noreply,
     socket
     |> put_flash(:info, "Package deleted")
     |> push_redirect(to: Routes.packages_index_path(socket, :index))}
  end

  def handle_event("save", %{"package" => package_params}, socket) do
    save_package(socket, socket.assigns.live_action, package_params)
  end

  defp save_package(socket, :edit, package_params) do
    case Packages.update_package(socket.assigns.package, package_params) do
      {:ok, package} ->
        {:noreply,
         socket
         |> put_flash(:info, "Package updated successfully")
         |> push_redirect(to: Routes.packages_show_path(socket, :show, package))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_package(socket, :new, package_params) do
    case Packages.create_package(package_params) do
      {:ok, package} ->
        {:noreply,
         socket
         |> put_flash(:info, "Package created successfully")
         |> push_redirect(to: Routes.packages_show_path(socket, :show, package))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
