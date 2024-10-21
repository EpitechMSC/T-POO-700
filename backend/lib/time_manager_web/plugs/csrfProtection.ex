defmodule TimeManagerWeb.Plugs.CSRFProtection do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, json: 2]

  @csrf_param "_csrf_token"
  @csrf_header "x-csrf-token"

  def init(default), do: default

  def call(conn, _opts) do
    if Application.get_env(:time_manager, :env) == :test do
      conn
    else
      conn = assign_csrf_token(conn)

      if is_csrf_check_required(conn) do
        verify_csrf_token(conn)
      else
        conn
      end
    end
  end

  defp assign_csrf_token(conn) do
    if get_session(conn, "_csrf_token") do
      conn
    else
      csrf_token = generate_csrf_token()
      put_session(conn, "_csrf_token", csrf_token)
    end
  end

  def generate_csrf_token do
    :crypto.strong_rand_bytes(32) |> Base.encode64()
  end

  defp is_csrf_check_required(conn) do
    conn.method in ["POST", "PUT", "DELETE"]
  end

  defp verify_csrf_token(conn) do
    csrf_token = get_csrf_token(conn)

    if valid_csrf_token?(get_session(conn, "_csrf_token"), csrf_token) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Invalid CSRF token"})
      |> halt()
    end
  end

  defp get_csrf_token(conn) do
    get_req_header(conn, @csrf_header)
    |> List.first() ||
      Map.get(conn.params, @csrf_param) ||
      ""
  end

  defp valid_csrf_token?(session_token, received_token) do
    session_token == received_token
  end
end
