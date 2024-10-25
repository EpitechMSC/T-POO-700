defmodule TimeManagerWeb.ContratControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ContratsFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.User
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
      role = role_fixture(name: "User")
      user = user_fixture(role: role.id)
      token = user_token_fixture(user, role)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/contrats")
      assert json_response(conn, 200) == []
    end
  end

  defp create_contrat(_) do
    contrat = contrat_fixture()
    %{contrat: contrat}
  end
end
