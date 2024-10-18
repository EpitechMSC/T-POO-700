defmodule TimeManager.ContratsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Contrats` context.
  """

  @doc """
  Generate a contrat.
  """
  def contrat_fixture(attrs \\ %{}) do
    {:ok, contrat} =
      attrs
      |> Enum.into(%{
        temps: 42
      })
      |> TimeManager.Contrats.create_contrat()

    contrat
  end
end
