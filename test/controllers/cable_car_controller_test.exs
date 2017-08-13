defmodule CableCarSpotter.CableCarControllerTest do
  use CableCarSpotterWeb.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, cable_car_path(conn, :index, "en"))
    assert html_response(conn, 200) =~ "All Cable Cars"
  end

  test "shows chosen resource", %{conn: conn} do
    cable_car = insert_line() |> insert_cable_car(%{ car_number: "No. 123"})

    conn = get conn, cable_car_path(conn, :show, "en", cable_car)
    assert html_response(conn, 200) =~ "No. 123"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cable_car_path(conn, :show, "en", -1)
    end
  end
end
