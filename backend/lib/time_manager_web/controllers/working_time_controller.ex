defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Work
  alias TimeManagerWeb.Response
  alias TimeManager.Work.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    page_size = Map.get(params, "page_size", "10") |> String.to_integer()

    case Work.list_workingtimes(page, page_size) do
      {:ok, %Response{} = response} ->
        json(conn, response)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Work.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time.id}")
      |> json(working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)
    json(conn, working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{} = updated_working_time} <-
           Work.update_working_time(working_time, working_time_params) do
      json(conn, updated_working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Work.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_by_userid(conn, %{"id" => user_id}) do
    case Integer.parse(user_id) do
      {user_id_int, ""} ->
        page = Map.get(conn.query_params, "page", "1") |> String.to_integer()
        page_size = Map.get(conn.query_params, "page_size", "10") |> String.to_integer()

        case Work.find_working_times_by_userid(user_id_int, page, page_size) do
          {:ok, %Response{} = response} ->
            json(conn, response)

          {:error, :not_found} ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "No working times found for the given user"})

          {:error, :bad_request} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Invalid user ID"})
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid user ID"})
    end
  end

  def search_by_userid_and_date_range(conn, %{"id" => id}) do
    conn = Plug.Conn.fetch_query_params(conn)

    if !valid_user_id?(id) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid user ID"})
    else
      start_date_as_string = conn.query_params["start"]

      if is_nil(start_date_as_string) do
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Start Date was not provided"})
      else
        end_date_as_string = conn.query_params["end"]

        end_date =
          case end_date_as_string do
            nil ->
              nil

            _ ->
              case NaiveDateTime.from_iso8601(end_date_as_string) do
                {:ok, parsed_date} -> parsed_date
                {:error, _reason} -> nil
              end
          end

        case NaiveDateTime.from_iso8601(start_date_as_string) do
          {:ok, start_date} ->
            case TimeManager.Work.find_working_time_for_user_and_date_range(
                   id,
                   start_date,
                   end_date
                 ) do
              {:ok, works} ->
                json(conn, works)

              {:error, :not_found} ->
                conn
                |> put_status(:not_found)
                |> json(%{error: "WorkingTime not found"})

              {:error, :bad_request} ->
                conn
                |> put_status(:bad_request)
                |> json(%{error: "Start Date was not provided"})
            end

          {:error, _reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Invalid start date format"})
        end
      end
    end
  end

  def stats(conn, %{"id" => id}) do
    case Work.get_working_time_stats(id) do
      {:ok, stats} ->
        json(conn, stats)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No working times found for the given user"})
    end
  end

  def weekly_stats(conn, %{"user_id" => user_id}) do
    working_times = Work.get_weekly_working_times(user_id)
    json(conn, working_times)
  end

  def monthly_stats(conn, %{"user_id" => user_id}) do
    working_times = Work.get_monthly_working_times(user_id)
    json(conn, working_times)
  end

  def yearly_stats(conn, %{"user_id" => user_id}) do
    working_times = Work.get_yearly_working_times(user_id)
    json(conn, working_times)
  end

  defp valid_user_id?(id) do
    case Integer.parse(id) do
      {_, ""} -> true
      _ -> false
    end
  end
end
