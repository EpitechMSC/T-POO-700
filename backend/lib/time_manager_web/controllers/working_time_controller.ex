defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Work
  alias TimeManager.Work.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Work.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Work.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Work.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Work.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
  def search_by_userid_and_date_range(conn, %{"id" => id, "start" => start_date_as_string} = params) do
    end_date =
      case Map.get(params, "end") do
        nil -> nil # `end` is not provided, set it to nil
        end_date_as_string ->
          # Parse the `end` date and handle both success and failure cases
          case NaiveDateTime.from_iso8601(end_date_as_string) do
            {:ok, parsed_date} -> parsed_date # If parsing succeeds, return the parsed date
            {:error, _reason} -> nil          # If parsing fails, return nil
          end
        end
    {:ok, start_date} = NaiveDateTime.from_iso8601(start_date_as_string)

    case Work.find_working_time_for_user_and_date_range(id,start_date,end_date) do
      {:ok, works} ->
        render(conn, :index, workingtimes: works)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "WorkingTime not found"})

      {:error, :bad_request} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Start Date was not provided"})
    end
  end
end
