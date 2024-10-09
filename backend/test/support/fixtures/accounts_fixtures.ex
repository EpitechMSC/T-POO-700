defmodule TimeManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "some username #{System.unique_integer()}",
        email: "some_email#{System.unique_integer()}@example.com"
      })
      |> TimeManager.Accounts.create_user()

    user
  end
end
