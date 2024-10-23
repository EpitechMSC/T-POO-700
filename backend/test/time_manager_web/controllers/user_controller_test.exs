defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures
  alias TimeManager.Accounts.User

  @invalid_attrs %{username: nil, email: nil, password: nil}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users when authenticated", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      # Create additional users to ensure listing works
      user_fixture()
      user_fixture()

      conn = get(conn, ~p"/api/users")

      response_data = json_response(conn, 200)["data"]

      assert length(response_data) > 0

      assert Enum.all?(response_data, fn user ->
               Map.has_key?(user, "id") and Map.has_key?(user, "username")
             end)
    end

    test "returns forbidden for unauthenticated user", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert response(conn, 401)
    end
  end

  describe "create user" do
    test "renders user when data is valid and supervisor token is provided", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      username = "user_#{:rand.uniform(1000)}"
      email = "user_#{:rand.uniform(1000)}@gmail.com"
      password = "secure_password_#{:rand.uniform(1000)}"
      role_id = role_fixture().id

      conn =
        post(conn, ~p"/api/users",
          user: %{
            username: username,
            email: email,
            password: password,
            role: role_id
          }
        )

      assert %{"username" => ^username, "email" => ^email, "role" => ^role_id} =
               json_response(conn, 201)
    end

    test "fails when a non-supervisor tries to create a user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/users",
          user: %{
            username: "invalid_user",
            email: "invalid@example.com",
            password: "password123",
            role: role_fixture().id
          }
        )

      assert json_response(conn, 403)["error"] ==
               "Forbidden: Only Supervisors can create new users."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "fails when required fields are missing", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/users",
          user: %{
            username: nil,
            email: nil,
            password: nil,
            role: nil
          }
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "fails when email format is invalid", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/users",
          user: %{
            username: "valid_username",
            email: "invalid_email_format",
            password: "valid_password",
            role: role_fixture().id
          }
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "supervisor can update any field", %{conn: conn, user: %User{id: id} = _user} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      new_role = role_fixture()

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{id}",
          user: %{
            username: "new_username",
            email: "new_email@example.com",
            role: new_role.id
          }
        )

      assert json_response(conn, 200)["username"] == "new_username"
      assert json_response(conn, 200)["role"] == new_role.id
    end

    test "ordinary user can only update their own email and username", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{user.id}",
          user: %{
            username: "new_user_username",
            email: "new_user_email@example.com"
          }
        )

      assert json_response(conn, 200)["username"] == "new_user_username"
      assert json_response(conn, 200)["email"] == "new_user_email@example.com"
    end

    test "ordinary user cannot update role", %{conn: conn} do
      role = role_fixture(name: "User")
      supervisor_role = role_fixture(name: "Supervisor")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{user.id}",
          user: %{
            username: "new_user_username",
            email: "new_user_email@example.com",
            role: supervisor_role
          }
        )

      assert json_response(conn, 200)
      assert json_response(conn, 200)["role"] == role.id
      assert json_response(conn, 200)["role"] !== supervisor_role.id
    end

    test "returns not found when user does not exist", %{conn: conn} do
      fake_user_id = 999
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{fake_user_id}",
          user: %{
            username: "new_username",
            email: "new_email@example.com"
          }
        )

      assert json_response(conn, 404)["error"] == "User not found"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "supervisor can delete a user", %{conn: conn, user: %User{id: id}} do
      role = role_fixture(name: "Supervisor")
      supervisor = user_fixture(role: role.id)
      token = user_token_fixture(supervisor, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/users/#{id}")
      assert response(conn, 204)
    end

    test "returns not found when user does not exist", %{conn: conn} do
      role = role_fixture(name: "Supervisor")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/users/999")
      assert json_response(conn, 404)["error"] == "User not found"
    end

    test "ordinary user cannot delete another user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/users/#{user_fixture().id}")
      assert json_response(conn, 403)["error"] == "Forbidden: Only Supervisors can delete users."
    end
  end

  describe "find users by email or username" do
    setup do
      user = user_fixture(username: "john_doe", email: "john@example.com", contrat: 1)
      user1 = user_fixture(username: "jane_doe", email: "jane@example.com", contrat: 2)
      %{user: user, user1: user1}
    end

    test "returns users matching the email", %{conn: conn, user: %User{id: user_id} = user} do
      role = role_fixture(name: "User")
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search?email=john")

      response_data = json_response(conn, 200)

      assert response_data == [
               %{
                 "id" => user_id,
                 "username" => user.username,
                 "email" => user.email,
                 "role" => user.role,
                 "contrat" => user.contrat
               }
             ]
    end

    test "returns users matching the username", %{conn: conn, user1: %User{id: user1_id} = user1} do
      role = role_fixture(name: "User")
      token = user_token_fixture(user1, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search?username=jane")

      response_data = json_response(conn, 200)

      assert response_data == [
               %{
                 "id" => user1_id,
                 "username" => user1.username,
                 "email" => user1.email,
                 "role" => user1.role,
                 "contrat" => user1.contrat
               }
             ]
    end

    test "returns error when both email and username are nil", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search")

      response_data = json_response(conn, 400)
      assert response_data == %{"error" => "Either 'email' or 'username' must be provided."}
    end

    test "returns not found when no user matches", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search?email=unknown")

      response_data = json_response(conn, 404)
      assert response_data == %{"error" => "No users found"}
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
