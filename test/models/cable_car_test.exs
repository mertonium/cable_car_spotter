defmodule CableCarSpotter.CableCarTest do
  use CableCarSpotter.ModelCase, async: true

  alias CableCarSpotter.CableCar

  @valid_attrs %{
    car_number: "No. 187",
    description: "Probably some long description on the history of this cable car.",
    line_id: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CableCar.changeset(%CableCar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CableCar.changeset(%CableCar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
