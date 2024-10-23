defmodule TimeManager.Repo.Migrations.CreateTeamMemberships do
  use Ecto.Migration

  def change do
    create table(:team_memberships) do
      add :team_id, references(:teams, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:team_memberships, [:team_id])
    create index(:team_memberships, [:user_id])
  end
end
