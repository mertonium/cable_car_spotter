defmodule CableCarSpotter.PageControllerTest do
  use CableCarSpotterWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, page_path(conn, :index, "en")
    assert html_response(conn, 200) =~ "Cable Car Spotter"
  end
end
