defmodule TimeManagerWeb.TeamMembershipControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TeamsFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Teams.TeamMembership

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_memberships for Supervisor", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/team_memberships")

      assert json_response(conn, 200)["data"] == []
    end

    test "returns forbidden error for User", %{conn: conn} do
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role_id: user_role.id})
      user_token = user_token_fixture(user, user_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> get(~p"/api/team_memberships")

      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  describe "create team_membership" do
    test "renders team_membership when data is valid for Supervisor", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role_id: user_role.id})

      valid_attrs = %{team_id: team.id, user_id: user.id}

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> post(~p"/api/team_memberships", team_membership: valid_attrs)

      assert json_response(conn, 201)
    end

    test "returns forbidden error for User", %{conn: conn} do
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role_id: user_role.id})
      user_token = user_token_fixture(user, user_role)

      valid_attrs = %{team_id: 1, user_id: 1}

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> post(~p"/api/team_memberships", team_membership: valid_attrs)

      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end

    test "renders errors when data is invalid for Supervisor", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> post(~p"/api/team_memberships", team_membership: %{team_id: nil, user_id: nil})

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_membership" do
    test "renders team_membership when data is valid for Supervisor", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      user = user_fixture(%{role_id: supervisor_role.id})

      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      valid_update_attrs = %{team_id: team.id, user_id: user.id}

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> put(~p"/api/team_memberships/#{team_membership.id}",
          team_membership: valid_update_attrs
        )

      assert json_response(conn, 200)
    end

    test "returns forbidden error for User", %{conn: conn} do
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role_id: user_role.id})
      user_token = user_token_fixture(user, user_role)

      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> put(~p"/api/team_memberships/#{team_membership.id}",
          team_membership: %{team_id: nil, user_id: nil}
        )

      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  describe "delete team_membership" do
    test "deletes chosen team_membership for Supervisor", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      user = user_fixture(%{role_id: supervisor_role.id})

      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/team_memberships/#{team_membership.id}")

      assert response(conn, 204)
    end

    test "returns forbidden error for User", %{conn: conn} do
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role_id: user_role.id})
      user_token = user_token_fixture(user, user_role)

      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> delete(~p"/api/team_memberships/#{team_membership.id}")

      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end

    test "returns not found error if team_membership does not exist", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/team_memberships/999999")

      assert json_response(conn, 404)["error"] == "Team membership not found"
    end
  end
end
