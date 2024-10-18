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
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

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
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn =
        post(conn, ~p"/api/workingtimes", working_time: Map.put(@invalid_attrs, :user_id, user.id))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]

    test "renders working_time when data is valid", %{
      conn: conn,
      working_time: %WorkingTime{id: id} = working_time
    } do
      user = user_fixture()
      token = user_token_fixture(user)

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
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = put(conn, ~p"/api/workingtimes/#{working_time.id}", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = delete(conn, ~p"/api/workingtimes/#{working_time.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtimes/#{working_time.id}")
      end
    end
  end

  defp create_working_time(_) do
    user = user_fixture()
    working_time = working_time_fixture(user_id: user.id)
    %{working_time: working_time}
  end
end
