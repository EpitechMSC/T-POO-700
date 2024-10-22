defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:manager_id])
    |> validate_required([:manager_id])
  end
end
