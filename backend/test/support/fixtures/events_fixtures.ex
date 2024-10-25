defmodule TimeManager.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        all_day: true,
        end: ~U[2024-10-23 09:08:00Z],
        start: ~U[2024-10-23 09:08:00Z],
        title: "some title",
        team_id: nil
      })
      |> TimeManager.Events.create_event()

    event
  end
end
