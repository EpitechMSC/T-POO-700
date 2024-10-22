defmodule TimeManagerWeb.TeamMembershipController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.TeamMembership

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    team_memberships = Teams.list_team_memberships()
    render(conn, :index, team_memberships: team_memberships)
  end

  def create(conn, %{"team_membership" => team_membership_params}) do
    with {:ok, %TeamMembership{} = team_membership} <- Teams.create_team_membership(team_membership_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/team_memberships/#{team_membership}")
      |> render(:show, team_membership: team_membership)
    end
  end

  def show(conn, %{"id" => id}) do
    team_membership = Teams.get_team_membership!(id)
    render(conn, :show, team_membership: team_membership)
  end

  def update(conn, %{"id" => id, "team_membership" => team_membership_params}) do
    team_membership = Teams.get_team_membership!(id)

    with {:ok, %TeamMembership{} = team_membership} <- Teams.update_team_membership(team_membership, team_membership_params) do
      render(conn, :show, team_membership: team_membership)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_membership = Teams.get_team_membership!(id)

    with {:ok, %TeamMembership{}} <- Teams.delete_team_membership(team_membership) do
      send_resp(conn, :no_content, "")
    end
  end
end
