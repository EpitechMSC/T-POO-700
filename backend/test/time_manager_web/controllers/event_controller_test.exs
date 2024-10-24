defmodule TimeManagerWeb.EventControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.EventsFixtures
  import TimeManager.AccountsFixtures
  import TimeManager.TeamsFixtures

  describe "index" do
    test "lists all events for a specific team", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      user_role = role_fixture(%{name: "User"})
      user = user_fixture(%{role: user_role.id})
      user_token = user_token_fixture(user, user_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user_token}")
        |> get(~p"/api/teams/#{team.id}/events")

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      manager_token = user_token_fixture(manager, manager_role)

      team = team_fixture(%{manager_id: manager.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token}")
        |> post(~p"/api/teams/#{team.id}/events", event: %{title: "some title", start: ~U[2024-10-23 09:08:00Z], end: ~U[2024-10-23 09:08:00Z], all_day: true, team_id: team.id})

      assert json_response(conn, 201)
    end
  end

  describe "show" do
    test "shows a specific event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      event = event_fixture(%{team_id: team.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/#{team.id}/events/#{event.id}")

      assert json_response(conn, 200)["id"] == event.id
    end

    test "returns 404 for a non-existing event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> get(~p"/api/teams/#{team.id}/events/999")

      assert json_response(conn, 404)
    end
  end

  describe "update" do
    test "supervisor updates an event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      event = event_fixture(%{team_id: team.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> put(~p"/api/teams/#{team.id}/events/#{event.id}", event: %{title: "updated title", start: ~U[2024-10-24 09:08:00Z], end: ~U[2024-10-24 09:08:00Z], all_day: false, team_id: team.id})

      assert %{"id" => id} = json_response(conn, 200)
      assert id == event.id

      conn = get(conn, ~p"/api/teams/#{team.id}/events/#{event.id}")
      assert json_response(conn, 200)["title"] == "updated title"
    end

    test "returns error when updating a non-existing event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> put(~p"/api/teams/#{team.id}/events/999", event: %{title: "updated title", team_id: team.id})

      assert json_response(conn, 404)
    end
  end

  describe "delete" do
    test "supervisor deletes an event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})
      event = event_fixture(%{team_id: team.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/teams/#{team.id}/events/#{event.id}")

      assert response(conn, 204)

    end

    test "returns error when deleting a non-existing event", %{conn: conn} do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role: supervisor_role.id})
      supervisor_token = user_token_fixture(supervisor, supervisor_role)

      team = team_fixture(%{manager_id: supervisor.id})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{supervisor_token}")
        |> delete(~p"/api/teams/#{team.id}/events/999")

      assert json_response(conn, 404)
    end
  end
end
