defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManagerWeb.Response
  use TimemanagerWeb.Decorators.EnsureRole

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

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, token} ->
        csrf_token = TimeManagerWeb.Plugs.CSRFProtection.generate_csrf_token()

        conn = put_session(conn, "_csrf_token", csrf_token)

        conn
        |> put_status(:ok)
        |> json(%{token: token, csrf_token: csrf_token})

      {:error, :invalid_credentials} ->
        IO.inspect("csrf_token")

        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
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
    |> json(%{error: "Email and password are required"})
    |> halt()
  end

  def me(conn, _params) do
    user_id = conn.assigns[:current_user]["id"]

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

  @decorate is_granted(["Supervisor"])
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
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
    current_user_role = conn.assigns[:current_user]["role"]
    current_user_id = conn.assigns[:current_user]["id"]

    case Accounts.get_user(id) do
      {:ok, user} ->
        # Filter out nil values from user_params
        user_params = Enum.reject(user_params, fn {_, v} -> is_nil(v) end) |> Map.new()

        if current_user_role == "Supervisor" do
          # Supervisors can update any user including role
          with {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
            json(conn, updated_user)
          else
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{errors: changeset})
          end
        else
          if current_user_id == user.id do
            # Exclude role from update
            allowed_params = Map.take(user_params, ["username", "email"])

            with {:ok, %User{} = updated_user} <- Accounts.update_user(user, allowed_params) do
              json(conn, updated_user)
            else
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{errors: changeset})
            end
          else
            conn
            |> put_status(:forbidden)
            |> json(%{error: "Forbidden: You can only update your own account."})
          end
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  @decorate is_granted(["Supervisor"])
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
