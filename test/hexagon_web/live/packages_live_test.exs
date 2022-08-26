defmodule HexagonWeb.PackagesLiveTest do
  use HexagonWeb.ConnCase

  import Hexagon.PackagesFactory
  import Phoenix.LiveViewTest

  @create_attrs %{name: "validpackagename", type: :hex}
  @update_attrs %{name: "validupdatepackagename"}
  @invalid_attrs %{name: "!!!INVALID!!!"}

  defp create_package(_) do
    %{package: insert(:package)}
  end

  describe "Index" do
    setup [:create_package]

    test "lists all packages", %{conn: conn, package: package} do
      {:ok, _index_live, html} = live(conn, Routes.packages_index_path(conn, :index))

      assert html =~ "Packages"
      assert html =~ package.name
    end
  end

  describe "Show" do
    setup [:create_package]

    test "displays name", %{conn: conn, package: package} do
      {:ok, _show_live, html} = live(conn, Routes.packages_show_path(conn, :show, package))

      assert html =~ package.name
    end
  end

  describe "Edit" do
    setup [:create_package]

    test "saves new package", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.packages_edit_path(conn, :new))

      assert index_live
             |> form("#package-form", package: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#package-form", test: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ "Package created successfully"
      assert html =~ @create_attrs.name
    end

    test "updates package", %{conn: conn, package: package} do
      {:ok, index_live, _html} = live(conn, Routes.packages_edit_path(conn, :edit, package))

      assert index_live
             |> form("#package-form", test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#package-form", test: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ "Package updated successfully"
      assert html =~ @update_attrs.name
    end

    test "deletes package", %{conn: conn, package: package} do
      {:ok, index_live, _html} = live(conn, Routes.packages_edit_path(conn, :edit, package))

      assert index_live |> element("a", "Delete") |> render_click()
      refute has_element?(index_live, "#package-#{package.id}")
    end
  end
end
