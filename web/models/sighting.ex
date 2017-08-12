defmodule CableCarSpotter.Sighting do
  use CableCarSpotter.Web, :model
  use Arc.Ecto.Schema

  schema "sightings" do
    field :comment, :string
    field :photo, CableCarSpotter.Photo.Type
    belongs_to :user, CableCarSpotter.User
    belongs_to :cable_car, CableCarSpotter.CableCar
    field :photo_taken_at, :utc_datetime
    field :geom, Geo.Point

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:comment, :user_id, :cable_car_id])
    |> cast_attachments(params, [:photo])
    |> validate_required([:user_id, :cable_car_id])
  end

  def changeset_with_photo(struct, params, metadata) do
    struct
    |> changeset(params)
    |> cast(metadata, [:photo_taken_at, :geom])
  end
end
