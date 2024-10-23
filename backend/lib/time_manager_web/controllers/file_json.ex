defmodule TimeManagerWeb.FileJSON do
  alias TimeManager.Files.File

  @doc """
  Renders a list of files.
  """
  def index(%{files: files}) do
    %{data: for(file <- files, do: data(file))}
  end

  @doc """
  Renders a single file.
  """
  def show(%{file: file}) do
    %{data: data(file)}
  end

  defp data(%File{} = file) do
    %{
      id: file.id,
      text: file.text
    }
  end
end
