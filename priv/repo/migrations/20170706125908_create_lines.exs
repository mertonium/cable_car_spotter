defmodule CableCarSpotter.Repo.Migrations.CreateLines do
  use Ecto.Migration

  def change do
    create table(:lines) do
      add :title, :string, null: false
    end

    create unique_index(:lines, [:title])
  end
end
