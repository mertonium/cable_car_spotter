defmodule CableCarSpotter.TestHelpers do
  alias CableCarSpotter.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      email: "user+#{Base.encode16(:crypto.strong_rand_bytes(8))}@cablecarspotter.com",
      password: "password"
    }, attrs)

    %CableCarSpotter.User{}
    |> CableCarSpotter.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_cable_car(line, attrs \\ %{}) do
    changes = Map.merge(%{
      car_number: "No. 187",
      description: "Home to various MDKs over the years, this car was re-numbered by MUNI in 1983 to match the police code for 'muder, death, kill'."
    }, attrs)

    line
    |> Ecto.build_assoc(:cable_cars, changes)
    |> Repo.insert!()
  end

  def insert_line(attrs \\ %{}) do
    changes = Map.merge(%{
      title: "Whatever St. #{Base.encode16(:crypto.strong_rand_bytes(8))}@cablecarspotter.com"
    }, attrs)

    %CableCarSpotter.Line{}
    |> CableCarSpotter.Line.changeset(changes)
    |> Repo.insert!()
  end

  def insert_sighting(attrs \\ %{}) do
    %CableCarSpotter.Sighting{}
    |> CableCarSpotter.Sighting.changeset(attrs)
    |> Repo.insert!
  end

end
