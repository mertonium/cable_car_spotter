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
    base_struct = user |> build_assoc(:sightings)

    changeset = case Map.has_key?(sighting_params, "photo") do
      true -> Sighting.changeset_with_photo(base_struct, sighting_params, extract_metadata_from_photo(sighting_params["photo"]))
      false -> Sighting.changeset(base_struct, sighting_params)
    end

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

  defp extract_metadata_from_photo(upload_plug) do
    {:ok, info} = Exexif.exif_from_jpeg_file(upload_plug.path)
    #IO.inspect info

    {:ok, datetime_taken} = Timex.parse(info.exif.datetime_original, "%Y:%m:%d %H:%M:%S", :strftime)

    %{
      geom: %Geo.Point{
        coordinates: {
          from_dms_to_decimal(info.gps.gps_latitude, info.gps.gps_latitude_ref),
          from_dms_to_decimal(info.gps.gps_longitude, info.gps.gps_longitude_ref)
        },
        srid: 4326
      },
      photo_taken_at: datetime_taken
    }
  end

  defp from_dms_to_decimal(dms, ref) do
    [d, m, s] = dms
    decimal_version = d + m/60.0 + s/3600.0

    case String.upcase(ref) do
      "W" -> decimal_version * -1
      "S" -> decimal_version * -1
      _   -> decimal_version
    end
  end
end
