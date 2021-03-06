defmodule CableCarSpotter.SightingTest do
  use CableCarSpotter.ModelCase

  alias CableCarSpotter.Sighting

  @valid_attrs %{user_id: 1, cable_car_id: 2, comment: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Sighting.changeset(%Sighting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sighting.changeset(%Sighting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
