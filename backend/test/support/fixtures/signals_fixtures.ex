defmodule TimeManager.SignalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Signals` context.
  """

  @doc """
  Generate a signal.
  """
  def signal_fixture(attrs \\ %{}) do
    {:ok, signal} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: true
      })
      |> TimeManager.Signals.create_signal()

    signal
  end
end
