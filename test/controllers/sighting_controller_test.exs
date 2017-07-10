defmodule CableCarSpotter.SightingControllerTest do
  use CableCarSpotter.ConnCase

  alias CableCarSpotter.Sighting
  @valid_attrs %{comment: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sighting_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sightings"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, sighting_path(conn, :new)
    assert html_response(conn, 200) =~ "New sighting"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, sighting_path(conn, :create), sighting: @valid_attrs
    assert redirected_to(conn) == sighting_path(conn, :index)
    assert Repo.get_by(Sighting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sighting_path(conn, :create), sighting: @invalid_attrs
    assert html_response(conn, 200) =~ "New sighting"
  end

  test "shows chosen resource", %{conn: conn} do
    sighting = Repo.insert! %Sighting{}
    conn = get conn, sighting_path(conn, :show, sighting)
    assert html_response(conn, 200) =~ "Show sighting"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sighting_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    sighting = Repo.insert! %Sighting{}
    conn = get conn, sighting_path(conn, :edit, sighting)
    assert html_response(conn, 200) =~ "Edit sighting"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    sighting = Repo.insert! %Sighting{}
    conn = put conn, sighting_path(conn, :update, sighting), sighting: @valid_attrs
    assert redirected_to(conn) == sighting_path(conn, :show, sighting)
    assert Repo.get_by(Sighting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sighting = Repo.insert! %Sighting{}
    conn = put conn, sighting_path(conn, :update, sighting), sighting: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit sighting"
  end

  test "deletes chosen resource", %{conn: conn} do
    sighting = Repo.insert! %Sighting{}
    conn = delete conn, sighting_path(conn, :delete, sighting)
    assert redirected_to(conn) == sighting_path(conn, :index)
    refute Repo.get(Sighting, sighting.id)
  end
end
