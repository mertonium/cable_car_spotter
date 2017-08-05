defmodule CableCarSpotter.LineTest do
  use CableCarSpotter.ModelCase, async: true

  alias CableCarSpotter.Line

  @valid_attrs %{title: "Powell Street Line"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Line.changeset(%Line{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Line.changeset(%Line{}, @invalid_attrs)
    refute changeset.valid?
  end

end
