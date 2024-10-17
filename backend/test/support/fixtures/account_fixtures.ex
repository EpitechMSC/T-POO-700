defmodule TimeManager.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Account` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManager.Account.create_role()

    role
  end
end
