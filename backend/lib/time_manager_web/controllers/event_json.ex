defmodule TimeManagerWeb.EventJSON do
  alias TimeManager.Events.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      title: event.title,
      start: event.start,
      end: event.end,
      all_day: event.all_day
    }
  end
end
