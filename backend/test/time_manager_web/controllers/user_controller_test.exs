defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.User

  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users when authenticated", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      user_fixture()
      user_fixture()

      conn = get(conn, ~p"/api/users")

      response_data = json_response(conn, 200)["data"]

      assert length(response_data) > 0

      assert Enum.all?(response_data, fn user ->
               Map.has_key?(user, "id") and Map.has_key?(user, "username")
             end)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      username = "user_#{:rand.uniform(1000)}"
      email = "user_#{:rand.uniform(1000)}@gmail.com"

      conn =
        post(conn, ~p"/api/users",
          user: %{
            username: username,
            email: email
          }
        )

      assert %{"id" => id, "username" => ^username, "email" => ^email} = json_response(conn, 201)

      conn = get(conn, ~p"/api/users/#{id}")
      assert %{"id" => ^id, "username" => ^username, "email" => ^email} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      token = user_token_fixture(user)

      new_username = "user_#{:rand.uniform(1000)}"
      new_email = "user.test@axel.axel"

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{id}",
          user: %{
            username: new_username,
            email: new_email
          }
        )

      assert %{"id" => ^id, "username" => ^new_username, "email" => ^new_email} =
               json_response(conn, 200)

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{"id" => ^id, "username" => ^new_username, "email" => ^new_email} =
               json_response(conn, 200)
    end

    test "returns not found when user does not exist", %{conn: conn} do
      fake_user_id = 999
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/users/#{fake_user_id}",
          user: %{
            username: "user_#{:rand.uniform(1000)}",
            email: "user_#{:rand.uniform(1000)}@gmail.com"
          }
        )

      assert json_response(conn, 404)["error"] == "User not found"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/users/#{user.id}")
      assert response(conn, 204)
    end

    test "returns not found when user does not exist", %{conn: conn} do
      token = user_token_fixture(user_fixture())

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/users/999")
      assert json_response(conn, 404)["error"] == "User not found"
    end
  end

  describe "find users by email or username" do
    setup do
      user1 = user_fixture(username: "john_doe", email: "john@example.com")
      user2 = user_fixture(username: "jane_doe", email: "jane@example.com")
      %{user1: user1, user2: user2}
    end

    test "returns users matching the email", %{conn: conn, user1: user1} do
      token = user_token_fixture(user1)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search?email=john")

      response_data = json_response(conn, 200)

      assert response_data == [
               %{"id" => user1.id, "username" => "john_doe", "email" => "john@example.com"}
             ]
    end

    test "returns users matching the username", %{conn: conn, user2: user2} do
      token = user_token_fixture(user2)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search?username=jane")

      response_data = json_response(conn, 200)

      assert response_data == [
               %{"id" => user2.id, "username" => "jane_doe", "email" => "jane@example.com"}
             ]
    end

    test "returns error when both email and username are nil", %{conn: conn, user1: user1} do
      token = user_token_fixture(user1)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/users/search")

      response_data = json_response(conn, 400)
      assert response_data == %{"error" => "Either 'email' or 'username' must be provided."}
    end

    test "returns not found when no user matches", %{conn: conn} do
      token = user_token_fixture(user_fixture())

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
