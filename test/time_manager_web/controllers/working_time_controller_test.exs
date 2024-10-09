defmodule TimeManagerWeb.WorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Work.WorkingTime

  @create_attrs %{
    start: ~N[2024-10-07 07:47:00],
    end: ~N[2024-10-07 07:47:00]
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
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "user_working_time" do
    setup [:create_user, :create_working_time]

    test "returns 404 when user not found", %{conn: conn} do
      non_existent_user_id = 99999
      working_time_id = "some-working-time-id"

      conn = get(conn, ~p"/api/workingtimes/#{non_existent_user_id}/#{working_time_id}")
      assert json_response(conn, 404)["error"] == "User not found"
    end

    test "returns 404 when working time not found for user", %{conn: conn, user: user} do
      non_existent_working_time_id = 99999

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{non_existent_working_time_id}")
      assert json_response(conn, 404)["error"] == "Working time not found for this user"
    end

    test "renders working time when user and working time exist", %{conn: conn, user: user} do
      IO.inspect(user, label: "User Before Working Time Creation")
      working_time = working_time_fixture(%{user_id: user.id})

      IO.inspect(working_time, label: "Working Time After Creation")

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{working_time.id}")

      expected_response = %{
        "id" => working_time.id,
        "start" => working_time.start |> NaiveDateTime.to_iso8601(),
        "end" => working_time.end |> NaiveDateTime.to_iso8601()
      }

      # Vérifier que la réponse JSON est celle attendue
      assert json_response(conn, 200)["data"] == expected_response
    end


    defp create_user(_) do
      user = user_fixture()
      %{user: user}
    end

    defp create_working_time(%{user: user}) do
      working_time = working_time_fixture(%{user_id: user.id})
      %{working_time: working_time}
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtimes", working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtimes/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T07:47:00",
               "start" => "2024-10-07T07:47:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtimes", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]

    test "renders working_time when data is valid", %{conn: conn, working_time: %WorkingTime{id: id} = _working_time} do
      conn = put(conn, ~p"/api/workingtimes/#{id}", working_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtimes/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-08T07:47:00",
               "start" => "2024-10-08T07:47:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      conn = put(conn, ~p"/api/workingtimes/#{working_time.id}", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      conn = delete(conn, ~p"/api/workingtimes/#{working_time.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtimes/#{working_time.id}")
      end
    end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
