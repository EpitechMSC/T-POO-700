defmodule TimeManager.Work do
  @moduledoc """
  The Work context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Work.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  def find_working_time_for_user_and_date_range(user_id, start_date, end_date) do
    cond do
      is_nil(user_id) or is_nil(start_date) ->
        {:error, :bad_request}

      not is_nil(start_date) and is_nil(end_date) ->
        Repo.all(from w in WorkingTime, where: w.user == ^user_id and w.start <= ^start_date)
        |> case do
          nil -> {:error, :not_found}
          works -> {:ok, works}
        end
      not is_nil(start_date) and not is_nil(end_date) ->
        Repo.all(from w in WorkingTime, where: w.user == ^user_id and w.start <= ^start_date and field(w, :end) >= ^end_date)
        |> case do
          nil -> {:error, :not_found}
          works -> {:ok, works}
        end
    end
  end
end
