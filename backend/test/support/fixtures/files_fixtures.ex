defmodule TimeManager.FilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Files` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> TimeManager.Files.create_file()

    file
  end
end
