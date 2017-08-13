defmodule CableCarSpotter.CableCar do
  use CableCarSpotter.Web, :model

  schema "cable_cars" do
    field :car_number, :string
    field :description, :string
    belongs_to :line, CableCarSpotter.Line

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
end