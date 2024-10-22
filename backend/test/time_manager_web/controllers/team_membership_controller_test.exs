defmodule TimeManagerWeb.TeamMembershipControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TeamsFixtures

  alias TimeManager.Teams.TeamMembership

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_memberships", %{conn: conn} do
      conn = get(conn, ~p"/api/team_memberships")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_membership" do
    test "renders team_membership when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/team_memberships", team_membership: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/team_memberships/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/team_memberships", team_membership: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_membership" do
    setup [:create_team_membership]

    test "renders team_membership when data is valid", %{conn: conn, team_membership: %TeamMembership{id: id} = team_membership} do
      conn = put(conn, ~p"/api/team_memberships/#{team_membership}", team_membership: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/team_memberships/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_membership: team_membership} do
      conn = put(conn, ~p"/api/team_memberships/#{team_membership}", team_membership: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_membership" do
    setup [:create_team_membership]

    test "deletes chosen team_membership", %{conn: conn, team_membership: team_membership} do
      conn = delete(conn, ~p"/api/team_memberships/#{team_membership}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/team_memberships/#{team_membership}")
      end
    end
  end

  defp create_team_membership(_) do
    team_membership = team_membership_fixture()
    %{team_membership: team_membership}
  end
end
