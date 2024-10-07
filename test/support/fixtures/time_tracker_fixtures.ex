defmodule TimeManager.TimeTrackerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.TimeTracker` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimeManager.TimeTracker.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-06 11:57:00]
      })
      |> TimeManager.TimeTracker.create_clock()

    clock
  end

  @doc """
  Generate a workin_time.
  """
  def workin_time_fixture(attrs \\ %{}) do
    {:ok, workin_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-06 11:58:00],
        start: ~N[2024-10-06 11:58:00]
      })
      |> TimeManager.TimeTracker.create_workin_time()

    workin_time
  end
end
