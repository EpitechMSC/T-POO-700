defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManagerWeb.Response

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    case Accounts.list_users() do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def login(conn, %{"email" => email}) do
    case Accounts.authenticate_by_email(email) do
      {:ok, user} ->
        json(conn, %{user: user})

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email"})
        |> halt()

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Unknown error"})
        |> halt()
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Email parameter is required"})
    |> halt()
  end

  def me(conn, _params) do
    user_id = conn.assigns[:current_user]

    case Accounts.get_user(user_id) do
      {:ok, user} ->
        json(conn, user)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  def search_by_email_or_username(conn, params) do
    email = Map.get(params, "email")
    username = Map.get(params, "username")

    case Accounts.find_users_by_email_or_username(email, username) do
      {:ok, users} ->
        json(conn, users)

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
      |> json(user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      {:ok, user} ->
        json(conn, user)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Accounts.get_user(id) do
      {:ok, user} ->
        user_params = Enum.reject(user_params, fn {_, v} -> is_nil(v) end) |> Map.new()

        with {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
          json(conn, updated_user)
        else
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      {:ok, user} ->
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        else
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end
end
