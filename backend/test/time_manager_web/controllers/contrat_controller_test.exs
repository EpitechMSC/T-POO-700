defmodule TimeManagerWeb.ContratControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ContratsFixtures

  alias TimeManager.Contrats.Contrat

  @create_attrs %{
    temps: 42
  }
  @update_attrs %{
    temps: 43
  }
  @invalid_attrs %{temps: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all contrats", %{conn: conn} do
      conn = get(conn, ~p"/api/contrats")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contrat" do
    test "renders contrat when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/contrats", contrat: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/contrats/#{id}")

      assert %{
               "id" => ^id,
               "temps" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/contrats", contrat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contrat" do
    setup [:create_contrat]

    test "renders contrat when data is valid", %{conn: conn, contrat: %Contrat{id: id} = contrat} do
      conn = put(conn, ~p"/api/contrats/#{contrat}", contrat: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/contrats/#{id}")

      assert %{
               "id" => ^id,
               "temps" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, contrat: contrat} do
      conn = put(conn, ~p"/api/contrats/#{contrat}", contrat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contrat" do
    setup [:create_contrat]

    test "deletes chosen contrat", %{conn: conn, contrat: contrat} do
      conn = delete(conn, ~p"/api/contrats/#{contrat}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/contrats/#{contrat}")
      end
    end
  end

  defp create_contrat(_) do
    contrat = contrat_fixture()
    %{contrat: contrat}
  end
end
