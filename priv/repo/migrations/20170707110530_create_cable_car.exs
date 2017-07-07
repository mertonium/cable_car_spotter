defmodule CableCarSpotter.Repo.Migrations.CreateCableCar do
  use Ecto.Migration

  def change do
    create table(:cable_cars) do
      add :car_number, :string
      add :description, :text
      add :line_id, references(:lines, on_delete: :nothing)

      timestamps()
    end
    create index(:cable_cars, [:line_id])

  end
end
