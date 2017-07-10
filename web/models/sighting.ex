defmodule CableCarSpotter.Sighting do
  use CableCarSpotter.Web, :model

  schema "sightings" do
    field :comment, :string
    belongs_to :user, CableCarSpotter.User
    belongs_to :cable_car, CableCarSpotter.CableCar

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:comment, :user_id, :cable_car_id])
    |> validate_required([:user_id, :cable_car_id])
  end
end
