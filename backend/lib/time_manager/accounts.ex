defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.User

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
  Finds users by partial email or username match.

  Returns:
    - {:ok, users} if one or more users are found
    - {:error, :not_found} if no users match
    - {:error, :bad_request} if both email and username are nil
  """
  def find_users_by_email_or_username(email, username) do
    cond do
      is_nil(email) and is_nil(username) ->
        {:error, :bad_request}

      not is_nil(email) and is_nil(username) ->
        users = Repo.all(from u in User, where: ilike(u.email, ^("#{email}%")))
        case users do
          [] -> {:error, :not_found}
          _ -> {:ok, users}
        end

      is_nil(email) and not is_nil(username) ->
        users = Repo.all(from u in User, where: ilike(u.username, ^("#{username}%")))
        case users do
          [] -> {:error, :not_found}
          _ -> {:ok, users}
        end

      not is_nil(email) and not is_nil(username) ->
        users = Repo.all(
          from u in User,
          where: ilike(u.email, ^("#{email}%")) or ilike(u.username, ^("#{username}%"))
        )
        case users do
          [] -> {:error, :not_found}
          _ -> {:ok, users}
        end
    end
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
end
