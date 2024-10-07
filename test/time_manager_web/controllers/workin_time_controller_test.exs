defmodule TimeManagerWeb.WorkinTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TimeTrackerFixtures

  alias TimeManager.TimeTracker.WorkinTime

  @create_attrs %{
    end: ~N[2024-10-06 11:58:00],
    start: ~N[2024-10-06 11:58:00]
  }
  @update_attrs %{
    end: ~N[2024-10-07 11:58:00],
    start: ~N[2024-10-07 11:58:00]
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtime", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtime")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workin_time" do
    test "renders workin_time when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", workin_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-06T11:58:00",
               "start" => "2024-10-06T11:58:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", workin_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workin_time" do
    setup [:create_workin_time]

    test "renders workin_time when data is valid", %{conn: conn, workin_time: %WorkinTime{id: id} = workin_time} do
      conn = put(conn, ~p"/api/workingtime/#{workin_time}", workin_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T11:58:00",
               "start" => "2024-10-07T11:58:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workin_time: workin_time} do
      conn = put(conn, ~p"/api/workingtime/#{workin_time}", workin_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workin_time" do
    setup [:create_workin_time]

    test "deletes chosen workin_time", %{conn: conn, workin_time: workin_time} do
      conn = delete(conn, ~p"/api/workingtime/#{workin_time}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtime/#{workin_time}")
      end
    end
  end

  defp create_workin_time(_) do
    workin_time = workin_time_fixture()
    %{workin_time: workin_time}
  end
end
