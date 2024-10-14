defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ClocksFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Clocks.Clock

  @create_attrs %{
    status: true,
    time: ~N[2024-10-07 07:44:00]
  }
  @update_attrs %{
    status: false,
    time: ~N[2024-10-08 07:44:00]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all clocks when authenticated", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/clocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = post(conn, ~p"/api/clocks", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => true,
               "time" => "2024-10-07T07:44:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = post(conn, ~p"/api/clocks", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clock" do
    setup [:create_clock]

    test "renders clock when data is valid", %{conn: conn, clock: %Clock{id: id} = clock} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = put(conn, ~p"/api/clocks/#{clock.id}", clock: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => false,
               "time" => "2024-10-08T07:44:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, clock: clock} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = put(conn, ~p"/api/clocks/#{clock.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clock" do
    setup [:create_clock]

    test "deletes chosen clock", %{conn: conn, clock: clock} do
      user = user_fixture()
      token = user_token_fixture(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = delete(conn, ~p"/api/clocks/#{clock.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clocks/#{clock.id}")
      end
    end
  end

  defp create_clock(_) do
    clock = clock_fixture()
    %{clock: clock}
  end
end
