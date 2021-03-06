defmodule CableCarSpotter.SightingControllerTest do
  use CableCarSpotterWeb.ConnCase
  alias CableCarSpotter.Sighting

  defp sighting_count(query), do: Repo.one(from s in query, select: count(s.id))

  setup %{conn: conn} = config do
    if email = config[:login_as] do
      user = insert_user(%{email: email})
      cable_car = insert_line() |> insert_cable_car()
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user, cable_car: cable_car}
    else
      :ok
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, sighting_path(conn, :new, "en")),
      get(conn, sighting_path(conn, :index, "en")),
      get(conn, sighting_path(conn, :show, "en", "123")),
      get(conn, sighting_path(conn, :edit, "en", "123")),
      put(conn, sighting_path(conn, :update, "en", "123", %{})),
      post(conn, sighting_path(conn, :create, "en", %{})),
      delete(conn, sighting_path(conn, :delete, "en", "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "j@tubbs.io"
  test "lists all the user's sightings on index", %{conn: conn, user: user, cable_car: cable_car} do
    other_user = insert_user()

    user_sighting = insert_sighting(%{
      user_id: user.id, cable_car_id: cable_car.id, comment: "Wow! That is awesome!"
    })
    other_sighting = insert_sighting(%{
      user_id: other_user.id, cable_car_id: cable_car.id, comment: "Wow! That is the devil!"
    })


    conn = get conn, sighting_path(conn, :index, "en")
    assert html_response(conn, 200) =~ "Your Sightings"
    assert String.contains?(conn.resp_body, user_sighting.comment)
    refute String.contains?(conn.resp_body, other_sighting.comment)
  end

  # CREATE
  @tag login_as: "j@tubbs.io"
  test "creates a sighting and redirects", %{conn: conn, user: user, cable_car: cable_car} do
    conn = post conn, sighting_path(conn, :create, "en"), sighting: %{ cable_car_id: cable_car.id }
    assert redirected_to(conn) == sighting_path(conn, :index, "en")
    assert Repo.get_by!(Sighting, %{cable_car_id: cable_car.id}).user_id == user.id
  end

  @tag login_as: "j@tubbs.io"
  test "does not create sighting and renders error when invalid", %{conn: conn} do
    count_before = sighting_count(Sighting)
    conn = post conn, sighting_path(conn, :create, "en"), sighting: %{}
    assert html_response(conn, 200) =~ "check the errors"
    assert sighting_count(Sighting) == count_before
  end

  @tag login_as: "j@tubbs.io"
  test "when a photo is provided and it has exif data, the date and gps info is extracted", %{conn: conn, user: user, cable_car: cable_car} do
    known_photo = %Plug.Upload{
      path: "test/fixtures/cable_car_with_exif.jpg",
      filename: "cable_car_with_exif.jpg"
    }
    known_timestamp = Timex.to_datetime({{2011, 4, 18}, {2, 11, 29}})
    known_gps = {37.79555555555555, -122.41000000000001}

    post conn, sighting_path(conn, :create, "en"), sighting: %{ cable_car_id: cable_car.id, photo: known_photo}
    inserted_sighting = Repo.get_by!(Sighting, %{cable_car_id: cable_car.id, user_id: user.id})

    assert Timex.compare(inserted_sighting.photo_taken_at, known_timestamp, :seconds) == 0
    assert is_geo_point(inserted_sighting.geom)
    assert inserted_sighting.geom.coordinates == known_gps
  end

  # SHOW
  @tag login_as: "j@tubbs.io"
  test "shows only a user's given sighting", %{conn: conn, user: user, cable_car: cable_car} do
    sighting1 = insert_sighting(%{
      user_id: user.id, cable_car_id: cable_car.id, comment: "Wow! That is awesome!"
    })
    sighting2 = insert_sighting(%{
      user_id: user.id, cable_car_id: cable_car.id, comment: "Ooops. That is the devil!"
    })

    conn = get conn, sighting_path(conn, :show, "en", sighting1.id)
    assert html_response(conn, 200) =~ sighting1.comment
    refute String.contains?(conn.resp_body, sighting2.comment)
  end

  @tag login_as: "j@tubbs.io"
  test "authorizes actions against access by other users", %{user: owner, conn: conn, cable_car: cable_car} do

    sighting = insert_sighting(%{user_id: owner.id, cable_car_id: cable_car.id})
    non_owner = insert_user()
    conn = assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, sighting_path(conn, :show, "en", sighting))
    end
    assert_error_sent :not_found, fn ->
      get(conn, sighting_path(conn, :edit, "en", sighting))
    end
    assert_error_sent :not_found, fn ->
      put(conn, sighting_path(conn, :update, "en", sighting, sighting: %{comment: "yo"}))
    end
    assert_error_sent :not_found, fn ->
      delete(conn, sighting_path(conn, :delete, "en", sighting))
    end
  end

  defp is_geo_point(%Geo.Point{}), do: true
  defp is_geo_point(_), do: false
end
