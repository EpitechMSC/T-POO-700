defmodule TimeManagerWeb.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller
  alias TimeManager.JWT

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> handle_token(conn, token)
      _ -> unauthorized_response(conn)
    end
  end

  defp handle_token(conn, token) do
    case JWT.verify(token, JWT.signer()) do
      {:ok, claims} ->
        case claims do
          %{"user_id" => user_id} -> assign(conn, :current_user, user_id)
          _ -> unauthorized_response(conn)
        end

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized", reason: reason})
        |> halt()
    end
  end

  defp unauthorized_response(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
    |> halt()
  end
end
