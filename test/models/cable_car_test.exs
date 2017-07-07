defmodule CableCarSpotter.CableCarTest do
  use CableCarSpotter.ModelCase

  alias CableCarSpotter.CableCar

  @valid_attrs %{car_number: "some content", description: "some content"}
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
