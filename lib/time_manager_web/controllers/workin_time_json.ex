defmodule TimeManagerWeb.WorkinTimeJSON do
  alias TimeManager.TimeTracker.WorkinTime

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(workin_time <- workingtime, do: data(workin_time))}
  end

  @doc """
  Renders a single workin_time.
  """
  def show(%{workin_time: workin_time}) do
    %{data: data(workin_time)}
  end

  defp data(%WorkinTime{} = workin_time) do
    %{
      id: workin_time.id,
      start: workin_time.start,
      end: workin_time.end
    }
  end
end
