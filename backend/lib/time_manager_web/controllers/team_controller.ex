defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManagerWeb.Response
  use TimemanagerWeb.Decorators.EnsureRole

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    case Teams.list_teams() do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def list_members(conn, %{"id" => team_id}) do
    case Teams.get_team(team_id) do
      {:ok, _team} ->
        case Teams.list_team_members(team_id) do
          {:ok, response} ->
            json(conn, response)

          {:error, reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team not found"})
    end
  end

  def get_team_by_user_id(conn, %{"user_id" => user_id}) do
    case Teams.get_team_by_user_id(user_id) do
      {:ok, team} ->
        json(conn, team)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team not found for this user"})
    end
  end

  @decorate is_granted(["Supervisor"])
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team.id}")
      |> json(%{team: team})
    end
  end

  def show(conn, %{"id" => id}) do
    case Teams.get_team(id) do
      {:ok, team} ->
        json(conn, team)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team not found"})
    end
  end

  @decorate is_granted(["Supervisor"])
  def update(conn, %{"id" => id, "team" => team_params}) do
    case Teams.get_team(id) do
      {:ok, team} ->
        with {:ok, %Team{} = updated_team} <- Teams.update_team(team, team_params) do
          json(conn, updated_team)
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team not found"})
    end
  end

  @decorate is_granted(["Supervisor"])
  def delete(conn, %{"id" => id}) do
    case Teams.get_team(id) do
      {:ok, team} ->
        with {:ok, %Team{}} <- Teams.delete_team(team) do
          send_resp(conn, :no_content, "")
        else
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team not found"})
    end
  end
end
