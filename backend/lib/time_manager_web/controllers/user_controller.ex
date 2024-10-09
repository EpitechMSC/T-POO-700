defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def search_by_email_or_username(conn, params) do
    email = Map.get(params, "email")
    username = Map.get(params, "username")

    case Accounts.find_users_by_email_or_username(email, username) do
      {:ok, users} ->
        render(conn, :index, users: users)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No users found"})

      {:error, :bad_request} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Either 'email' or 'username' must be provided."})
    end
  end


  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
