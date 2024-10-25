defmodule TimeManager.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :all_day, :boolean, default: false, null: false
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:team_id])
  end
end
