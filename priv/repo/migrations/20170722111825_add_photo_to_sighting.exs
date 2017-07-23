defmodule CableCarSpotter.Repo.Migrations.AddPhotoToSighting do
  use Ecto.Migration

  def change do
    alter table(:sightings) do
      add :photo, :string
    end
  end
end
