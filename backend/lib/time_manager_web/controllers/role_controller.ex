defmodule TimeManagerWeb.RoleController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Role
  alias TimeManagerWeb.Response

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    case Accounts.list_roles() do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Accounts.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/roles/#{role}")
      |> render(:show, role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Accounts.get_role!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Accounts.get_role!(id)

    with {:ok, %Role{} = role} <- Accounts.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Accounts.get_role!(id)

    with {:ok, %Role{}} <- Accounts.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
