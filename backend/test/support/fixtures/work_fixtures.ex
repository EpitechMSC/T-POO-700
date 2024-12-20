defmodule TimeManager.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Work` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 07:47:00],
        start: ~N[2024-10-07 07:47:00],
        user: nil
      })
      |> TimeManager.Work.create_working_time()

    working_time
  end
end
