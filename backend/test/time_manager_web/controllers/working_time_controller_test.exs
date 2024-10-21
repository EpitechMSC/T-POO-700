defmodule TimeManagerWeb.WorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Work.WorkingTime

  @create_attrs %{
    start: ~N[2024-10-07 07:47:00],
    end: ~N[2024-10-07 07:47:00],
    user_id: nil
  }
  @update_attrs %{
    start: ~N[2024-10-08 07:47:00],
    end: ~N[2024-10-08 07:47:00]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all working times when authenticated", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 200)["data"] == []
    end

    test "returns unauthorized if no token is provided", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/workingtimes", working_time: Map.put(@create_attrs, :user_id, user.id))

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/workingtimes/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T07:47:00",
               "start" => "2024-10-07T07:47:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/workingtimes",
          working_time: Map.put(@invalid_attrs, :user_id, user.id)
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]

    test "renders working_time when data is valid", %{
      conn: conn,
      working_time: %WorkingTime{id: id} = working_time
    } do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        put(conn, ~p"/api/workingtimes/#{working_time.id}",
          working_time: Map.put(@update_attrs, :user_id, user.id)
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/workingtimes/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-08T07:47:00",
               "start" => "2024-10-08T07:47:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = put(conn, ~p"/api/workingtimes/#{working_time.id}", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = delete(conn, ~p"/api/workingtimes/#{working_time.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtimes/#{working_time.id}")
      end
    end
  end

  describe "search_by_userid" do
    test "returns working times for a valid user with pagination", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      working_time_fixture(user: user.id)
      working_time_fixture(user: user.id)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/user/#{user.id}?page=1&page_size=10")

      assert json_response(conn, 200) != []
    end

    test "returns not_found when no working times exist for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/workingtimes/user/#{user.id}")
      assert json_response(conn, 200)["data"] == []
    end

    test "returns bad_request for invalid user ID", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/workingtimes/user/invalid")
      assert json_response(conn, 400)["error"] == "Invalid user ID"
    end
  end

  describe "search_by_userid_and_date_range" do
    test "returns working times in a valid date range", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      start_time = "2024-10-02T09:00:00"
      end_time = "2024-10-03T17:00:00"

      working_time_fixture(user: user.id, start: start_time, end: end_time)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        get(
          conn,
          ~p"/api/workingtimes/search/#{user.id}?start=2024-10-01T00:00:00&end=2024-10-08T23:59:59"
        )

      assert json_response(conn, 200)["data"] != []
    end

    test "returns not_found when no working times exist for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        get(
          conn,
          ~p"/api/workingtimes/search/#{user.id}?start=2024-10-01T00:00:00&end=2024-10-08T23:59:59"
        )

      assert json_response(conn, 404)["error"] == "WorkingTime not found"
    end

    test "returns bad_request for an invalid start date", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        get(conn, ~p"/api/workingtimes/search/#{user.id}?start=invalid&end=2024-10-31T23:59:59")

      assert json_response(conn, 400)["error"] == "Invalid start date format"
    end

    test "returns bad_request when no start date is provided", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/search/#{user.id}?end=2024-10-31T23:59:59")

      assert json_response(conn, 400)["error"] == "Start Date was not provided"
    end
  end

  describe "stats" do
    test "returns stats for a valid user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)
      working_time_fixture(user: user.id)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/stats/#{user.id}")

      assert json_response(conn, 200) != %{}
    end

    test "returns [] when no stats are available for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/stats/#{user.id}")

      assert json_response(conn, 200)
    end
  end

  describe "weekly stats" do
    test "returns weekly stats for a valid user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      working_time_fixture(user: user.id)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/weekly")

      assert json_response(conn, 200) != %{}
    end

    test "returns not_found when no weekly stats are available for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/weekly")

      assert json_response(conn, 200) == []
    end
  end

  describe "monthly stats" do
    test "returns monthly stats for a valid user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)
      working_time_fixture(user: user.id)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/monthly")

      assert json_response(conn, 200) != %{}
    end

    test "returns not_found when no monthly stats are available for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/monthly")

      assert json_response(conn, 200) == []
    end
  end

  describe "yearly stats" do
    test "returns yearly stats for a valid user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)
      working_time_fixture(user: user.id)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/yearly")

      assert json_response(conn, 200) != %{}
    end

    test "returns not_found when no yearly stats are available for the user", %{conn: conn} do
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/workingtimes/#{user.id}/yearly")

      assert json_response(conn, 200) == []
    end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
