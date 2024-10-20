defmodule TimeManagerWeb.RoleControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.Role

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roles when authenticated as Supervisor", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/roles")
      response_data = json_response(conn, 200)["data"]

      assert length(response_data) > 0
      assert Enum.all?(response_data, fn role ->
        Map.has_key?(role, "id") and Map.has_key?(role, "name")
      end)
    end

    test "returns forbidden for unauthenticated user", %{conn: conn} do
      conn = get(conn, ~p"/api/roles")
      assert response(conn, 401)
    end

    test "returns forbidden for non-supervisor user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/roles")
      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  describe "create role" do
    test "renders role when data is valid and supervisor token is provided", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = post(conn, ~p"/api/roles", role: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = post(conn, ~p"/api/roles", role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns forbidden for non-supervisor user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = post(conn, ~p"/api/roles", role: @create_attrs)
      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  describe "update role" do
    setup [:create_role]

    test "renders role when data is valid and supervisor token is provided", %{conn: conn, role: %Role{id: id} = role} do
      supervisor_role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: supervisor_role.id)
      token = user_token_fixture(supervisor, supervisor_role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = put(conn, ~p"/api/roles/#{role}", role: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, role: role} do
      supervisor_role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: supervisor_role.id)
      token = user_token_fixture(supervisor, supervisor_role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = put(conn, ~p"/api/roles/#{role}", role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns forbidden for non-supervisor user", %{conn: conn, role: role} do
      user_role = role_fixture(name: "User")
      user = user_fixture(role: user_role.id)
      token = user_token_fixture(user, user_role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = put(conn, ~p"/api/roles/#{role}", role: @update_attrs)
      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  describe "delete role" do
    setup [:create_role]

    test "deletes chosen role when authenticated as Supervisor", %{conn: conn, role: role} do
      supervisor_role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: supervisor_role.id)
      token = user_token_fixture(supervisor, supervisor_role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/roles/#{role}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/roles/#{role}")
      end
    end

    test "returns forbidden for non-supervisor user", %{conn: conn, role: role} do
      user_role = role_fixture(name: "User")
      user = user_fixture(role: user_role.id)
      token = user_token_fixture(user, user_role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = delete(conn, ~p"/api/roles/#{role}")
      assert json_response(conn, 403)["error"] == "Forbidden: Insufficient role"
    end
  end

  defp create_role(_) do
    role = role_fixture()
    %{role: role}
  end
end
