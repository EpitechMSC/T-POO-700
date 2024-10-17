defmodule TimeManager.Contrats do
  @moduledoc """
  The Contrats context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Contrats.Contrat

  @doc """
  Returns the list of contrats.

  ## Examples

      iex> list_contrats()
      [%Contrat{}, ...]

  """
  def list_contrats do
    Repo.all(Contrat)
  end

  @doc """
  Gets a single contrat.

  Raises `Ecto.NoResultsError` if the Contrat does not exist.

  ## Examples

      iex> get_contrat!(123)
      %Contrat{}

      iex> get_contrat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contrat!(id), do: Repo.get!(Contrat, id)

  @doc """
  Creates a contrat.

  ## Examples

      iex> create_contrat(%{field: value})
      {:ok, %Contrat{}}

      iex> create_contrat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contrat(attrs \\ %{}) do
    %Contrat{}
    |> Contrat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contrat.

  ## Examples

      iex> update_contrat(contrat, %{field: new_value})
      {:ok, %Contrat{}}

      iex> update_contrat(contrat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contrat(%Contrat{} = contrat, attrs) do
    contrat
    |> Contrat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contrat.

  ## Examples

      iex> delete_contrat(contrat)
      {:ok, %Contrat{}}

      iex> delete_contrat(contrat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contrat(%Contrat{} = contrat) do
    Repo.delete(contrat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contrat changes.

  ## Examples

      iex> change_contrat(contrat)
      %Ecto.Changeset{data: %Contrat{}}

  """
  def change_contrat(%Contrat{} = contrat, attrs \\ %{}) do
    Contrat.changeset(contrat, attrs)
  end
end
