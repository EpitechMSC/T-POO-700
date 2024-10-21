defmodule TimeManagerWeb.Plugs.EnsureRole do
  import Plug.Conn
  import Phoenix.Controller

  @role_hierarchy ["User", "Manager", "Supervisor"]

  def init(opts), do: opts

  def call(conn, required_roles) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})
        |> halt()

      %{"role" => user_role} ->
        if role_allowed?(user_role, required_roles) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Forbidden: Insufficient role"})
          |> halt()
        end
    end
  end

  defp role_allowed?(user_role, required_roles) do
    user_index = role_index(user_role)

    Enum.any?(required_roles, fn required_role ->
      user_index >= role_index(required_role)
    end)
  end

  defp role_index(role) do
    Enum.find_index(@role_hierarchy, fn r -> r == role end) || -1
  end
end
