defmodule TimeManagerWeb.TeamControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TeamsFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Teams.Team

  describe "index" do
    test "lists all teams", %{conn: conn} do
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role: user_role.id})
      user_token = user_token_fixture(user, user_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> get(~p"/api/teams")

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "list_members" do
    test "lists all members of a team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/#{team.id}/members")

      assert json_response(conn, 200) == []
    end

    test "returns not found when team does not exist", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/999/members")

      assert json_response(conn, 404)
    end
  end

  describe "create" do
    test "supervisor creates a team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> post(~p"/api/teams", team: %{manager_id: supervisor.id})

      assert json_response(conn, 201)
    end

    test "non-supervisor cannot create a team", %{conn: conn} do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      manager_token = user_token_fixture(manager, manager_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token}")
        |> post(~p"/api/teams", team: %{manager_id: manager.id})

      assert json_response(conn, 403)
    end
  end

  describe "show" do
    test "shows a specific team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/#{team.id}")

      assert json_response(conn, 200)["id"] == team.id
    end

    test "returns 404 for a non-existing team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/999")

      assert json_response(conn, 404)
    end
  end

  describe "update" do
    test "supervisor updates a team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> put(~p"/api/teams/#{team.id}", team: %{manager_id: manager.id})

      assert %{"id" => id} = json_response(conn, 200)
      assert id == team.id
    end

    test "non-supervisor cannot update a team", %{conn: conn} do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      manager_token = user_token_fixture(manager, manager_role)

      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token}")
        |> put(~p"/api/teams/#{team.id}", team: %{manager_id: manager.id})

      assert json_response(conn, 403)
    end

    test "returns error when updating a non-existing team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> put(~p"/api/teams/999", team: %{manager_id: manager.id})

      assert json_response(conn, 404)
    end
  end

  describe "delete" do
    test "supervisor deletes a team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/teams/#{team.id}")

      assert response(conn, 204)
    end

    test "non-supervisor cannot delete a team", %{conn: conn} do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      manager_token = user_token_fixture(manager, manager_role)

      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})

      team = team_fixture(%{manager_id: manager.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token}")
        |> delete(~p"/api/teams/#{team.id}")

      assert json_response(conn, 403)
    end

    test "returns error when deleting a non-existing team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/teams/999")

      assert json_response(conn, 404)
    end
  end
end
