defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Accounts.User
  alias TimeManager.Accounts.Role
  alias TimeManager.JWT

  @doc """
  Returns a paginated list of users.

  ## Examples

      iex> list_users(1, 10)
      {:ok, %Response{
        users: [%User{}, ...],
        total_pages: 5,
        current_page: 1,
        page_size: 10
      }}

  """
  def list_users(page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(User, :count, :id)

    users =
      User
      |> order_by([u], asc: u.username)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: users,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  def authenticate_by_email_and_password(email, password) do
    query =
      from u in User,
        join: r in Role,
        on: u.role == r.id,
        where: u.email == ^email,
        select: {u, r.name}

    case Repo.one(query) do
      nil ->
        {:error, :invalid_credentials}

      {%User{} = user, role_name} ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          claims = %{
            "user_id" => user.id,
            "role" => role_name,
            "exp" => DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix()
          }

          case JWT.generate_and_sign(claims, JWT.signer()) do
            {:ok, token, _claims} -> {:ok, token}
            {:error, reason} -> {:error, reason}
          end
        else
          {:error, :invalid_credentials}
        end
    end
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
        users = Repo.all(from u in User, where: ilike(u.email, ^"#{email}%"))

        case users do
          [] -> {:error, :not_found}
          _ -> {:ok, users}
        end

      is_nil(email) and not is_nil(username) ->
        users = Repo.all(from u in User, where: ilike(u.username, ^"#{username}%"))

        case users do
          [] -> {:error, :not_found}
          _ -> {:ok, users}
        end

      not is_nil(email) and not is_nil(username) ->
        users =
          Repo.all(
            from u in User,
              where: ilike(u.email, ^"#{email}%") or ilike(u.username, ^"#{username}%")
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
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
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
    |> User.update_changeset(attrs)
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

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles(page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(Role, :count, :id)

    roles =
      Role
      |> order_by([r], asc: r.name)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: roles,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end
