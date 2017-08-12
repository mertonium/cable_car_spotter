defmodule CableCarSpotter.Repo.Migrations.AddPhotoMetadataToSighting do
  use Ecto.Migration

  def change do
    alter table(:sightings) do
      add :photo_taken_at, :utc_datetime
      add :geom,           :geometry
    end
  end
end
