defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManagerWeb.Response

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    case Clocks.list_clocks() do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def last_clock(conn, %{"user" => user}) do
    case Clocks.get_last_clock(user) do
      {:ok, %Clock{} = clock} ->
        json(conn, clock)

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: reason})
    end
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> json(clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    json(conn, clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = updated_clock} <- Clocks.update_clock(clock, clock_params) do
      json(conn, updated_clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
