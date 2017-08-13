defmodule CableCarSpotter.Line do
  use CableCarSpotter.Web, :model

  schema "lines" do
    field :title, :string

    has_many :cable_cars, CableCarSpotter.CableCar
  end

  def titles_and_ids(query) do
    from l in query, select: {l.title, l.id}
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
