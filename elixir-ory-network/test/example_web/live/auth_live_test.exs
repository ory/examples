defmodule ExampleWeb.AuthLiveTest do
  use ExampleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Example.AccountsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_auth(_) do
    auth = auth_fixture()
    %{auth: auth}
  end

  describe "Index" do
    setup [:create_auth]

    test "lists all auth", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/auth")

      assert html =~ "Listing Auth"
    end

    test "saves new auth", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/auth")

      assert index_live |> element("a", "New Auth") |> render_click() =~
               "New Auth"

      assert_patch(index_live, ~p"/auth/new")

      assert index_live
             |> form("#auth-form", auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#auth-form", auth: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/auth")

      html = render(index_live)
      assert html =~ "Auth created successfully"
    end

    test "updates auth in listing", %{conn: conn, auth: auth} do
      {:ok, index_live, _html} = live(conn, ~p"/auth")

      assert index_live |> element("#auth-#{auth.id} a", "Edit") |> render_click() =~
               "Edit Auth"

      assert_patch(index_live, ~p"/auth/#{auth}/edit")

      assert index_live
             |> form("#auth-form", auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#auth-form", auth: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/auth")

      html = render(index_live)
      assert html =~ "Auth updated successfully"
    end

    test "deletes auth in listing", %{conn: conn, auth: auth} do
      {:ok, index_live, _html} = live(conn, ~p"/auth")

      assert index_live |> element("#auth-#{auth.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#auth-#{auth.id}")
    end
  end

  describe "Show" do
    setup [:create_auth]

    test "displays auth", %{conn: conn, auth: auth} do
      {:ok, _show_live, html} = live(conn, ~p"/auth/#{auth}")

      assert html =~ "Show Auth"
    end

    test "updates auth within modal", %{conn: conn, auth: auth} do
      {:ok, show_live, _html} = live(conn, ~p"/auth/#{auth}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Auth"

      assert_patch(show_live, ~p"/auth/#{auth}/show/edit")

      assert show_live
             |> form("#auth-form", auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#auth-form", auth: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/auth/#{auth}")

      html = render(show_live)
      assert html =~ "Auth updated successfully"
    end
  end
end
