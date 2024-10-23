defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    json(conn, teams)
  end

  def list_members(conn, %{"id" => team_id}) do
    members = Teams.list_team_members(team_id)
    json(conn, %{members: members})
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> json(%{team: team})
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    json(conn, team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = updated_team} <- Teams.update_team(team, team_params) do
      json(conn, updated_team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
