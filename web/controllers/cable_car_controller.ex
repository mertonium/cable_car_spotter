defmodule CableCarSpotter.CableCarController do
  use CableCarSpotter.Web, :controller

  alias CableCarSpotter.CableCar
  alias CableCarSpotter.Line

  plug :load_lines when action in [:new, :create, :edit, :update]

  def index(conn, _params) do
    cable_cars =
      Repo.all(CableCar)
      |> Repo.preload(:line)

    render(conn, "index.html", cable_cars: cable_cars)
  end

  def new(conn, _params) do
    changeset = CableCar.changeset(%CableCar{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cable_car" => cable_car_params}) do
    changeset = CableCar.changeset(%CableCar{}, cable_car_params)

    case Repo.insert(changeset) do
      {:ok, _cable_car} ->
        conn
        |> put_flash(:info, "Cable car created successfully.")
        |> redirect(to: cable_car_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cable_car = Repo.get!(CableCar, id)
      |> Repo.preload(:line)
    render(conn, "show.html", cable_car: cable_car)
  end

  def edit(conn, %{"id" => id}) do
    cable_car = Repo.get!(CableCar, id)
    changeset = CableCar.changeset(cable_car)
    render(conn, "edit.html", cable_car: cable_car, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cable_car" => cable_car_params}) do
    cable_car = Repo.get!(CableCar, id)
    changeset = CableCar.changeset(cable_car, cable_car_params)

    case Repo.update(changeset) do
      {:ok, cable_car} ->
        conn
        |> put_flash(:info, "Cable car updated successfully.")
        |> redirect(to: cable_car_path(conn, :show, cable_car))
      {:error, changeset} ->
        render(conn, "edit.html", cable_car: cable_car, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cable_car = Repo.get!(CableCar, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cable_car)

    conn
    |> put_flash(:info, "Cable car deleted successfully.")
    |> redirect(to: cable_car_path(conn, :index))
  end

  defp load_lines(conn, _) do
    query =
      Line
      |> Line.titles_and_ids
    lines = Repo.all query
    assign(conn, :lines, lines)
  end
end
