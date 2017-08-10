defmodule CableCarSpotter.UserControllerTest do
  use CableCarSpotter.ConnCase

  alias CableCarSpotter.User
  @valid_attrs %{email: "j@tubbs.io", password: "supersecret"}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new, "en")
    assert html_response(conn, 200) =~ "Register"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create, "en"), user: @valid_attrs
    assert redirected_to(conn) == sighting_path(conn, :index, "en")
    assert Repo.get_by(User, %{email: "j@tubbs.io"})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create, "en"), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Register"
  end
end
