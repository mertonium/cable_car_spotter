defmodule CableCarSpotter.CableCar do
  use CableCarSpotter.Web, :model

  schema "cable_cars" do
    field :car_number, :string
    field :description, :string
    belongs_to :line, CableCarSpotter.Line
    has_many :sightings, CableCarSpotter.Sighting

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:car_number, :description, :line_id])
    |> validate_required([:car_number, :description, :line_id])
    |> assoc_constraint(:line)
  end

  def numbers_and_ids(query) do
    from c in query, select: {c.car_number, c.id}
  end

  def by_car_number(query) do
    from c in query, order_by: fragment("split_part(car_number, ' ', 2)::int")
  end

  def with_user_sightings(query, user) do
    sightings = from(s in CableCarSpotter.Sighting, where: [user_id: ^user.id], order_by: [desc: s.inserted_at])
    from query, preload: [sightings: ^sightings]
  end
end
