defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.User

  @create_attrs %{
    username: "some username",
    email: "some_email@example.com"
  }
  @update_attrs %{
    username: "some updated username",
    email: "some_updated_email@example.com"
  }
  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some_email@example.com",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some_updated_email@example.com",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  describe "find users by email or username" do
    setup do
      user1 = user_fixture(username: "john_doe", email: "john@example.com")
      user2 = user_fixture(username: "jane_doe", email: "jane@example.com")
      %{user1: user1, user2: user2}
    end

    test "returns users matching the email", %{conn: conn, user1: user1} do
      conn = get(conn, ~p"/api/users/search?email=john")
      assert json_response(conn, 200)["data"] == [
               %{"id" => user1.id, "username" => "john_doe", "email" => "john@example.com"}
             ]
    end

    test "returns users matching the username", %{conn: conn, user2: user2} do
      conn = get(conn, ~p"/api/users/search?username=jane")
      assert json_response(conn, 200)["data"] == [
               %{"id" => user2.id, "username" => "jane_doe", "email" => "jane@example.com"}
             ]
    end

    test "returns users matching both email and username", %{conn: conn, user1: user1, user2: user2} do
      conn = get(conn, ~p"/api/users/search?email=john&username=jane")
      assert json_response(conn, 200)["data"] == [
               %{"id" => user1.id, "username" => "john_doe", "email" => "john@example.com"},
               %{"id" => user2.id, "username" => "jane_doe", "email" => "jane@example.com"}
             ]
    end

    test "returns error when both email and username are nil", %{conn: conn} do
      conn = get(conn, ~p"/api/users/search")
      assert json_response(conn, 400)["error"] == "Either 'email' or 'username' must be provided."
    end

    test "returns not found when no user matches", %{conn: conn} do
      conn = get(conn, ~p"/api/users/search?email=unknown")
      assert json_response(conn, 404)["error"] == "No users found"
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
