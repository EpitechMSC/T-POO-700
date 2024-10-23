defmodule TimeManager.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        manager_id: nil
      })
      |> TimeManager.Teams.create_team()

    team
  end

  @doc """
  Generate a team_membership.
  """
  def team_membership_fixture(attrs \\ %{}) do
    {:ok, team_membership} =
      attrs
      |> Enum.into(%{
        team_id: nil,
        user_id: nil
      })
      |> TimeManager.Teams.create_team_membership()

    team_membership
  end
end
