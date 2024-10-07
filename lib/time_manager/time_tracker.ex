defmodule TimeManager.TimeTracker do
  @moduledoc """
  The TimeTracker context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.TimeTracker.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Finds a user by email or username.

  Returns:
    - {:ok, user} if found
    - {:error, :not_found} if no user matches
    - {:error, :bad_request} if both email and username are nil
  """
  def find_user_by_email_or_username(email, username) do
    cond do
      is_nil(email) and is_nil(username) ->
        {:error, :bad_request}

      not is_nil(email) and is_nil(username) ->
        Repo.one(from u in User, where: u.email == ^email)
        |> case do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end

      is_nil(email) and not is_nil(username) ->
        Repo.one(from u in User, where: u.username == ^username)
        |> case do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end

      not is_nil(email) and not is_nil(username) ->
        Repo.one(from u in User, where: u.email == ^email or u.username == ^username)
        |> case do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TimeManager.TimeTracker.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.TimeTracker.WorkinTime

  @doc """
  Returns the list of workingtime.

  ## Examples

      iex> list_workingtime()
      [%WorkinTime{}, ...]

  """
  def list_workingtime do
    Repo.all(WorkinTime)
  end

  @doc """
  Gets a single workin_time.

  Raises `Ecto.NoResultsError` if the Workin time does not exist.

  ## Examples

      iex> get_workin_time!(123)
      %WorkinTime{}

      iex> get_workin_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workin_time!(id), do: Repo.get!(WorkinTime, id)

  @doc """
  Creates a workin_time.

  ## Examples

      iex> create_workin_time(%{field: value})
      {:ok, %WorkinTime{}}

      iex> create_workin_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workin_time(attrs \\ %{}) do
    %WorkinTime{}
    |> WorkinTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workin_time.

  ## Examples

      iex> update_workin_time(workin_time, %{field: new_value})
      {:ok, %WorkinTime{}}

      iex> update_workin_time(workin_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workin_time(%WorkinTime{} = workin_time, attrs) do
    workin_time
    |> WorkinTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workin_time.

  ## Examples

      iex> delete_workin_time(workin_time)
      {:ok, %WorkinTime{}}

      iex> delete_workin_time(workin_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workin_time(%WorkinTime{} = workin_time) do
    Repo.delete(workin_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workin_time changes.

  ## Examples

      iex> change_workin_time(workin_time)
      %Ecto.Changeset{data: %WorkinTime{}}

  """
  def change_workin_time(%WorkinTime{} = workin_time, attrs \\ %{}) do
    WorkinTime.changeset(workin_time, attrs)
  end
end
