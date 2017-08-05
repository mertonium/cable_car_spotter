defmodule CableCarSpotter.UserRepoTest do
  use CableCarSpotter.ModelCase

  alias CableCarSpotter.User

  @valid_attrs %{email: "j@tubbs.io", password: "12345"}

  test "converts unique_constraint on email to error" do
    insert_user(%{email: "wang@jubjub.xyz"})
    attrs = Map.put(@valid_attrs, :email, "wang@jubjub.xyz")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:email, {"has already been taken", []}} in changeset.errors
  end
end
