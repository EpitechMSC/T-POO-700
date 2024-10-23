defmodule TimeManager.Teams.TeamMembership do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :team_id, :user_id]}
  schema "team_memberships" do
    field :team_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_membership, attrs) do
    team_membership
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
  end
end
