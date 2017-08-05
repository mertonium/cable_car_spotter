defmodule CableCarSpotter.CableCarRepoTest do
  use CableCarSpotter.ModelCase

  alias CableCarSpotter.CableCar

  @valid_attrs %{
    car_number: "No. 187",
    description: "Probably some long description on the history of this cable car.",
    line_id: 1
  }

  test "converts assoc_constraint into an error" do
    changeset = CableCar.changeset(%CableCar{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:line, {"does not exist", []}} in changeset.errors
  end

  test "by_car_number/1 orders the car by line number" do
    line = insert_line()
    insert_cable_car(line, %{car_number: "No. 5", description: "foo"})
    insert_cable_car(line, %{car_number: "No. 1", description: "bar"})
    insert_cable_car(line, %{car_number: "No. 10", description: "baz"})

    query = CableCar |> CableCar.by_car_number()
    query = from c in query, select: c.car_number
    assert Repo.all(query) == ["No. 1", "No. 5", "No. 10"]
  end
end
