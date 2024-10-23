defmodule TimeManagerWeb.TeamMembershipJSON do
  alias TimeManager.Teams.TeamMembership

  @doc """
  Renders a list of team_memberships.
  """
  def index(%{team_memberships: team_memberships}) do
    %{data: for(team_membership <- team_memberships, do: data(team_membership))}
  end

  @doc """
  Renders a single team_membership.
  """
  def show(%{team_membership: team_membership}) do
    %{data: data(team_membership)}
  end

  defp data(%TeamMembership{} = team_membership) do
    %{
      id: team_membership.id
    }
  end
end
