defmodule CableCarSpotter.SightingController do
  use CableCarSpotter.Web, :controller
  alias CableCarSpotter.Sighting
  alias CableCarSpotter.CableCar

  plug :load_cable_cars, except: [:index]
  plug :authenticate_user

  def index(conn, _params, user) do
    sightings =
      Repo.all(user_sightings(user))
      |> Repo.preload(:cable_car)

    render(conn, "index.html", sightings: sightings)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:sightings)
      |> Sighting.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sighting" => sighting_params}, user) do
    changeset =
      user
      |> build_assoc(:sightings)
      |> Sighting.changeset(sighting_params)

    case Repo.insert(changeset) do
      {:ok, _sighting} ->
        conn
        |> put_flash(:info, gettext("Sighting created successfully."))
        |> redirect(to: sighting_path(conn, :index, conn.assigns.locale))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    sighting = Repo.get!(user_sightings(user), id)
               |> Repo.preload(:cable_car)
    render(conn, "show.html", sighting: sighting)
  end

  def edit(conn, %{"id" => id}, user) do
    sighting = Repo.get!(user_sightings(user), id)
    changeset = Sighting.changeset(sighting)
    render(conn, "edit.html", sighting: sighting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sighting" => sighting_params}, user) do
    sighting = Repo.get!(user_sightings(user), id)
    changeset = Sighting.changeset(sighting, sighting_params)

    case Repo.update(changeset) do
      {:ok, sighting} ->
        conn
        |> put_flash(:info, gettext("Sighting updated successfully."))
        |> redirect(to: sighting_path(conn, :show, sighting))
      {:error, changeset} ->
        render(conn, "edit.html", sighting: sighting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    sighting = Repo.get!(user_sightings(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sighting)

    conn
    |> put_flash(:info, gettext("Sighting deleted successfully."))
    |> redirect(to: sighting_path(conn, :index, conn.assigns.locale))
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  defp load_cable_cars(conn, _) do
    query =
      CableCar
      |> CableCar.by_car_number
      |> CableCar.numbers_and_ids
    cable_cars = Repo.all query
    assign(conn, :cable_cars, cable_cars)
  end

  defp user_sightings(user) do
    assoc(user, :sightings)
  end
end
