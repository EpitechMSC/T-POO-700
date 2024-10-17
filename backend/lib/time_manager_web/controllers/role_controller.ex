defmodule TimeManagerWeb.RoleController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Account.Role

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    roles = Account.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Account.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/roles/#{role}")
      |> render(:show, role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Account.get_role!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Account.get_role!(id)

    with {:ok, %Role{} = role} <- Account.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Account.get_role!(id)

    with {:ok, %Role{}} <- Account.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
