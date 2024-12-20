defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string

      add :contrat, references(:contrats, on_delete: :nothing)
      add :role, references(:roles, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
