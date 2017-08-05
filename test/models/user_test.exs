defmodule CableCarSpotter.UserTest do
  use CableCarSpotter.ModelCase, async: true

  alias CableCarSpotter.User

  @valid_attrs %{email: "j@tubbs.io", password: "supersecret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration_changeset password must be at least 6 chars long" do
    attrs = Map.put(@valid_attrs, :password, "12345")
    changeset = User.registration_changeset(%User{}, attrs)

    assert {:password, {"should be at least %{count} character(s)", [count: 6, validation: :length, min: 6]}}
      in changeset.errors
  end

  test "registration_changeset password must not be more than 100 chars long" do
    attrs = Map.put(@valid_attrs, :password, String.duplicate("x", 101))
    changeset = User.registration_changeset(%User{}, attrs)

    assert {:password, {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]}}
      in changeset.errors
  end

  test "registration_changeset with valid attributes hashes password" do
    attrs = Map.put(@valid_attrs, :password, "123456")
    changeset = User.registration_changeset(%User{}, attrs)
    %{password: pass, password_hash: pass_hash} = changeset.changes

    assert changeset.valid?
    assert pass_hash
    assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
  end
end
