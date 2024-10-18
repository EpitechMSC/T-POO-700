defmodule TimeManager.Repo.Migrations.CreateContrats do
  use Ecto.Migration

  def change do
    create table(:contrats) do
      add :temps, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
