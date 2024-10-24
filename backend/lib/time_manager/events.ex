defmodule TimeManager.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Events.Event
  alias TimeManagerWeb.Response

  @doc """
  Returns the list of events with optional pagination.

  ## Examples

      iex> list_events(1, 10)
      {:ok, %Response{
        data: [%Event{}, ...],
        pagination: %{
          total_pages: 5,
          current_page: 1,
          page_size: 10
        }
      }}

  """
  def list_events(page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(Event, :count, :id)

    events =
      Event
      |> order_by([e], asc: e.start)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %Response{
       data: events,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  @doc """
  Returns the list of events for a specific team with optional pagination.

  ## Examples

      iex> list_events_for_team(1, 1, 10)
      {:ok, %Response{
        data: [%Event{}, ...],
        pagination: %{
          total_pages: 5,
          current_page: 1,
          page_size: 10
        }
      }}

  """
  def list_events_for_team(team_id, page \\ 1, page_size \\ 10) do
    total_count =
      Event
      |> where([e], e.team_id == ^team_id)
      |> Repo.aggregate(:count, :id)

    events =
      Event
      |> where([e], e.team_id == ^team_id)
      |> order_by([e], asc: e.start)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %Response{
       data: events,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

  @doc """
  Gets a single event.

  Returns:
    - {:ok, %Event{}} if the event is found
    - {:error, :not_found} if the event does not exist

  ## Examples

      iex> get_event(123)
      {:ok, %Event{}}

      iex> get_event(456)
      {:error, :not_found}

  """
  def get_event(id) do
    case Repo.get(Event, id) do
      nil -> {:error, :not_found}
      event -> {:ok, event}
    end
  end

  @doc """
  Creates an event.

  Returns:
    - {:ok, %Event{}} if the creation is successful
    - {:error, %Ecto.Changeset{}} if the creation fails

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an event.

  Returns:
    - {:ok, %Event{}} if the update is successful
    - {:error, %Ecto.Changeset{}} if the update fails

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an event.

  Returns:
    - {:ok, %Event{}} if the deletion is successful
    - {:error, %Ecto.Changeset{}} if the deletion fails

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
