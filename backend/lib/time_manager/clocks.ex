defmodule TimeManager.Clocks do
  @moduledoc """
  The Clocks context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Clocks.Clock

  @doc """
  Returns a paginated list of clocks.

  ## Examples

      iex> list_clocks(1, 10)
      {:ok, %Response{
        clocks: [%Clock{}, ...],
        total_pages: 5,
        current_page: 1,
        page_size: 10
      }}

  """
  def list_clocks(page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(Clock, :count, :id)

    clocks =
      Clock
      |> order_by([c], desc: c.time)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: clocks,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  @doc """
  Returns a list of clocks filtered by status with pagination.

  ## Examples

      iex> list_clocks_by_status(:active, 1, 10)
      {:ok, %Response{
        clocks: [%Clock{}, ...],
        total_pages: 5,
        current_page: 1,
        page_size: 10
      }}

  """
  def list_clocks_by_status(status, page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(from(c in Clock, where: c.status == ^status), :count, :id)

    clocks =
      Clock
      |> where([c], c.status == ^status)
      |> order_by([c], desc: c.time)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: clocks,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  @doc """
  Returns a list of clocks filtered by a specific attribute with pagination.

  ## Examples

      iex> list_clocks_by_name("My Clock", 1, 10)
      {:ok, %Response{
        clocks: [%Clock{}, ...],
        total_pages: 5,
        current_page: 1,
        page_size: 10
      }}

  """
  def list_clocks_by_name(name, page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(from(c in Clock, where: c.name == ^name), :count, :id)

    clocks =
      Clock
      |> where([c], c.name == ^name)
      |> order_by([c], desc: c.time)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: clocks,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
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

  def get_last_clock(user) do
    query =
      from(c in Clock,
        where: c.user == ^user,
        order_by: [desc: c.inserted_at],
        limit: 1
      )

    case Repo.one(query) do
      nil -> {:error, "No clock entry found for user with id #{user}"}
      clock -> {:ok, clock}
    end
  end
end
