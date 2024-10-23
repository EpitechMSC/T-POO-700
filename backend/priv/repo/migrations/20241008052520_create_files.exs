defmodule TimeManager.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :text, :text

      timestamps(type: :utc_datetime)
    end
  end
end
