defmodule CableCarSpotter.CableCarControllerTest do
  use CableCarSpotter.ConnCase

  alias CableCarSpotter.CableCar
  @valid_attrs %{car_number: "some content", description: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cable_car_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cable cars"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, cable_car_path(conn, :new)
    assert html_response(conn, 200) =~ "New cable car"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, cable_car_path(conn, :create), cable_car: @valid_attrs
    assert redirected_to(conn) == cable_car_path(conn, :index)
    assert Repo.get_by(CableCar, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cable_car_path(conn, :create), cable_car: @invalid_attrs
    assert html_response(conn, 200) =~ "New cable car"
  end

  test "shows chosen resource", %{conn: conn} do
    cable_car = Repo.insert! %CableCar{}
    conn = get conn, cable_car_path(conn, :show, cable_car)
    assert html_response(conn, 200) =~ "Show cable car"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cable_car_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    cable_car = Repo.insert! %CableCar{}
    conn = get conn, cable_car_path(conn, :edit, cable_car)
    assert html_response(conn, 200) =~ "Edit cable car"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cable_car = Repo.insert! %CableCar{}
    conn = put conn, cable_car_path(conn, :update, cable_car), cable_car: @valid_attrs
    assert redirected_to(conn) == cable_car_path(conn, :show, cable_car)
    assert Repo.get_by(CableCar, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cable_car = Repo.insert! %CableCar{}
    conn = put conn, cable_car_path(conn, :update, cable_car), cable_car: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit cable car"
  end

  test "deletes chosen resource", %{conn: conn} do
    cable_car = Repo.insert! %CableCar{}
    conn = delete conn, cable_car_path(conn, :delete, cable_car)
    assert redirected_to(conn) == cable_car_path(conn, :index)
    refute Repo.get(CableCar, cable_car.id)
  end
end
