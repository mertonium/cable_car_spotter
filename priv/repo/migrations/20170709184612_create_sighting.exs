defmodule CableCarSpotter.Repo.Migrations.CreateSighting do
  use Ecto.Migration

  def change do
    create table(:sightings) do
      add :comment, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :cable_car_id, references(:cable_cars, on_delete: :nothing)

      timestamps()
    end
    create index(:sightings, [:user_id])
    create index(:sightings, [:cable_car_id])

  end
end
