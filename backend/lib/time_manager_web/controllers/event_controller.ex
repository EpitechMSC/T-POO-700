defmodule TimeManagerWeb.EventController do
  use TimeManagerWeb, :controller

  alias TimeManager.Events
  alias TimeManager.Events.Event
  alias TimeManagerWeb.Response
  use TimemanagerWeb.Decorators.EnsureRole

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"id" => team_id}) do
    case Events.list_events_for_team(team_id) do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  @decorate is_granted(["Supervisor", "Manager"])
  def create(conn, %{"id" => team_id, "event" => event_params}) do
    case Events.create_event(Map.put(event_params, "team_id", team_id)) do
      {:ok, %Event{} = event} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/teams/#{team_id}/events/#{event.id}")
        |> json(%{event: event})

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def show(conn, %{"id" => id}) do
    case Events.get_event(id) do
      {:ok, event} ->
        json(conn, event)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Event not found"})
    end
  end

  @decorate is_granted(["Supervisor", "Manager"])
  def update(conn, %{"id" => id, "event" => event_params}) do
    case Events.get_event(id) do
      {:ok, event} ->
        case Events.update_event(event, event_params) do
          {:ok, %Event{} = updated_event} ->
            json(conn, updated_event)

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Event not found"})
    end
  end

  @decorate is_granted(["Supervisor", "Manager"])
  def delete(conn, %{"id" => id}) do
    case Events.get_event(id) do
      {:ok, event} ->
        case Events.delete_event(event) do
          {:ok, %Event{}} ->
            send_resp(conn, :no_content, "")

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Event not found"})
    end
  end
end
