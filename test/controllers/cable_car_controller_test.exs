defmodule CableCarSpotter.CableCarControllerTest do
  use CableCarSpotter.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cable_car_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cable cars"
  end

  test "shows chosen resource", %{conn: conn} do
    cable_car = insert_line() |> insert_cable_car(%{ car_number: "No. 123"})

    conn = get conn, cable_car_path(conn, :show, cable_car)
    assert html_response(conn, 200) =~ "No. 123"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cable_car_path(conn, :show, -1)
    end
  end
end
