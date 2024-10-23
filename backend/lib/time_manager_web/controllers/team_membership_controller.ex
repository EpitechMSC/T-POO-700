defmodule TimeManagerWeb.TeamMembershipController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.TeamMembership
  alias TimeManagerWeb.Response
  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    case Teams.list_team_memberships() do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def create(conn, %{"team_membership" => team_membership_params}) do
    with {:ok, %TeamMembership{} = team_membership} <-
           Teams.create_team_membership(team_membership_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/team_memberships/#{team_membership.id}")
      |> json(%{team_membership: team_membership})
    end
  end

  def show(conn, %{"id" => id}) do
    case Teams.get_team_membership(id) do
      {:ok, team_membership} ->
        json(conn, team_membership)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team membership not found"})
    end
  end

  def update(conn, %{"id" => id, "team_membership" => team_membership_params}) do
    case Teams.get_team_membership(id) do
      {:ok, team_membership} ->
        with {:ok, %TeamMembership{} = updated_team_membership} <-
               Teams.update_team_membership(team_membership, team_membership_params) do
          json(conn, updated_team_membership)
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team membership not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Teams.get_team_membership(id) do
      {:ok, team_membership} ->
        with {:ok, %TeamMembership{}} <- Teams.delete_team_membership(team_membership) do
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
        |> json(%{error: "Team membership not found"})
    end
  end
end
