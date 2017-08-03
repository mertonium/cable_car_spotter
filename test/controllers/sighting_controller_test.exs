defmodule CableCarSpotter.SightingControllerTest do
  use CableCarSpotter.ConnCase
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
      get(conn, sighting_path(conn, :new)),
      get(conn, sighting_path(conn, :index)),
      get(conn, sighting_path(conn, :show, "123")),
      get(conn, sighting_path(conn, :edit, "123")),
      put(conn, sighting_path(conn, :update, "123", %{})),
      post(conn, sighting_path(conn, :create, %{})),
      delete(conn, sighting_path(conn, :delete, "123"))
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


    conn = get conn, sighting_path(conn, :index)
    assert html_response(conn, 200) =~ "Your Sightings"
    assert String.contains?(conn.resp_body, user_sighting.comment)
    refute String.contains?(conn.resp_body, other_sighting.comment)
  end

  @tag login_as: "j@tubbs.io"
  test "creates a sighting and redirects", %{conn: conn, user: user, cable_car: cable_car} do
    conn = post conn, sighting_path(conn, :create), sighting: %{ cable_car_id: cable_car.id }
    assert redirected_to(conn) == sighting_path(conn, :index)
    assert Repo.get_by!(Sighting, %{cable_car_id: cable_car.id}).user_id == user.id
  end

  @tag login_as: "j@tubbs.io"
  test "does not create sighting and renders error when invalid", %{conn: conn} do
    count_before = sighting_count(Sighting)
    conn = post conn, sighting_path(conn, :create), sighting: %{}
    assert html_response(conn, 200) =~ "check the errors"
    assert sighting_count(Sighting) == count_before
  end

  @tag login_as: "j@tubbs.io"
  test "shows only a user's given sighting", %{conn: conn, user: user, cable_car: cable_car} do
    sighting1 = insert_sighting(%{
      user_id: user.id, cable_car_id: cable_car.id, comment: "Wow! That is awesome!"
    })
    sighting2 = insert_sighting(%{
      user_id: user.id, cable_car_id: cable_car.id, comment: "Ooops. That is the devil!"
    })


    conn = get conn, sighting_path(conn, :show, sighting1.id)
    assert html_response(conn, 200) =~ sighting1.comment
    refute String.contains?(conn.resp_body, sighting2.comment)
  end

end
