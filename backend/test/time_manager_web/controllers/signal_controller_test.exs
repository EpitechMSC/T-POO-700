defmodule TimeManagerWeb.SignalControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.SignalsFixtures

  alias TimeManager.Signals.Signal

  @create_attrs %{
    name: "some name",
    status: true
  }
  @update_attrs %{
    name: "some updated name",
    status: false
  }
  @invalid_attrs %{name: nil, status: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all signals", %{conn: conn} do
      conn = get(conn, ~p"/api/signals")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create signal" do
    test "renders signal when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/signals", signal: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/signals/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "status" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/signals", signal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update signal" do
    setup [:create_signal]

    test "renders signal when data is valid", %{conn: conn, signal: %Signal{id: id} = signal} do
      conn = put(conn, ~p"/api/signals/#{signal}", signal: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/signals/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "status" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, signal: signal} do
      conn = put(conn, ~p"/api/signals/#{signal}", signal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete signal" do
    setup [:create_signal]

    test "deletes chosen signal", %{conn: conn, signal: signal} do
      conn = delete(conn, ~p"/api/signals/#{signal}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/signals/#{signal}")
      end
    end
  end

  defp create_signal(_) do
    signal = signal_fixture()
    %{signal: signal}
  end
end
