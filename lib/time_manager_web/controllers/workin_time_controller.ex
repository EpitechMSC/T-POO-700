defmodule TimeManagerWeb.WorkinTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeTracker
  alias TimeManager.TimeTracker.WorkinTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtime = TimeTracker.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"workin_time" => workin_time_params}) do
    with {:ok, %WorkinTime{} = workin_time} <- TimeTracker.create_workin_time(workin_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{workin_time}")
      |> render(:show, workin_time: workin_time)
    end
  end

  def show(conn, %{"id" => id}) do
    workin_time = TimeTracker.get_workin_time!(id)
    render(conn, :show, workin_time: workin_time)
  end

  def update(conn, %{"id" => id, "workin_time" => workin_time_params}) do
    workin_time = TimeTracker.get_workin_time!(id)

    with {:ok, %WorkinTime{} = workin_time} <- TimeTracker.update_workin_time(workin_time, workin_time_params) do
      render(conn, :show, workin_time: workin_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    workin_time = TimeTracker.get_workin_time!(id)

    with {:ok, %WorkinTime{}} <- TimeTracker.delete_workin_time(workin_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
