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
  def list_workingtimes(page \\ 1, page_size \\ 10) do
    total_count = Repo.aggregate(WorkingTime, :count, :id)

    workingtimes =
      WorkingTime
      |> order_by([w], asc: w.start)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: workingtimes,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
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

  def find_working_times_by_userid(user_id, page \\ 1, page_size \\ 10) do
    total_count =
      WorkingTime
      |> where([w], w.user == ^user_id)
      |> Repo.aggregate(:count, :id)

    workingtimes =
      WorkingTime
      |> where([w], w.user == ^user_id)
      |> order_by([w], asc: w.start)
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_pages = div(total_count + page_size - 1, page_size)

    {:ok,
     %TimeManagerWeb.Response{
       data: workingtimes,
       pagination: %{
         total_pages: total_pages,
         current_page: page,
         page_size: page_size
       }
     }}
  end

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

  def find_working_time_for_user_and_date_range(
        user_id,
        start_date,
        end_date \\ nil,
        page \\ 1,
        page_size \\ 10
      ) do
    cond do
      is_nil(user_id) or is_nil(start_date) ->
        {:error, :bad_request}

      is_nil(end_date) ->
        query =
          from w in WorkingTime,
            where: w.user == ^user_id and w.start >= ^start_date,
            or_where: w.end >= ^start_date or is_nil(w.end),
            order_by: [asc: w.start],
            limit: ^page_size,
            offset: ^((page - 1) * page_size)

        total_count = Repo.aggregate(query, :count, :id)
        workingtimes = Repo.all(query)
        total_pages = div(total_count + page_size - 1, page_size)

        case workingtimes do
          [] ->
            {:error, :not_found}

          works ->
            {:ok,
             %TimeManagerWeb.Response{
               data: works,
               pagination: %{
                 total_pages: total_pages,
                 current_page: page,
                 page_size: page_size
               }
             }}
        end

      true ->
        query =
          from w in WorkingTime,
            where:
              w.user == ^user_id and w.start >= ^start_date and
                (is_nil(w.end) or w.end <= ^end_date),
            order_by: [asc: w.start],
            limit: ^page_size,
            offset: ^((page - 1) * page_size)

        total_count = Repo.aggregate(query, :count, :id)
        workingtimes = Repo.all(query)
        total_pages = div(total_count + page_size - 1, page_size)

        case workingtimes do
          [] ->
            {:error, :not_found}

          works ->
            {:ok,
             %TimeManagerWeb.Response{
               data: works,
               pagination: %{
                 total_pages: total_pages,
                 current_page: page,
                 page_size: page_size
               }
             }}
        end
    end
  end

  def get_working_time_stats(user_id) do
    today = Date.utc_today()
    start_of_week = Date.beginning_of_week(today)

    start_of_current_month = Timex.beginning_of_month(today)
    start_of_previous_month = Timex.shift(start_of_current_month, months: -1)
    end_of_previous_month = Timex.end_of_month(start_of_previous_month)

    worked_today_query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) == ^today and not is_nil(w.end),
        select: sum(fragment("EXTRACT(EPOCH FROM ? - ?) / 3600", w.end, w.start))
      )

    worked_this_week_query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_week and
            not is_nil(w.end),
        select: sum(fragment("EXTRACT(EPOCH FROM ? - ?) / 3600", w.end, w.start))
      )

    total_days_worked_query =
      from(w in WorkingTime,
        where: w.user == ^user_id and not is_nil(w.end),
        select: count(fragment("DISTINCT ?::date", w.start))
      )

    worked_this_month_query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_current_month and
            not is_nil(w.end),
        select: sum(fragment("EXTRACT(EPOCH FROM ? - ?) / 3600", w.end, w.start))
      )

    worked_last_month_query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_previous_month and
            fragment("?::date", w.start) <= ^end_of_previous_month and not is_nil(w.end),
        select: sum(fragment("EXTRACT(EPOCH FROM ? - ?) / 3600", w.end, w.start))
      )

    worked_today = Repo.one(worked_today_query) || Decimal.new(0)
    worked_this_week = Repo.one(worked_this_week_query) || Decimal.new(0)
    total_days_worked = Repo.one(total_days_worked_query) || 0
    worked_this_month = Repo.one(worked_this_month_query) || Decimal.new(0)
    worked_last_month = Repo.one(worked_last_month_query) || Decimal.new(0)

    stats = %{
      worked_today: Float.round(Decimal.to_float(worked_today), 2),
      worked_this_week: Float.round(Decimal.to_float(worked_this_week), 2),
      total_days_worked: total_days_worked,
      worked_this_month: Float.round(Decimal.to_float(worked_this_month), 2),
      worked_last_month: Float.round(Decimal.to_float(worked_last_month), 2)
    }

    {:ok, stats}
  end

  def get_weekly_working_times(user_id) do
    today = Date.utc_today()
    {:ok, start_of_month} = Date.new(today.year, today.month, 1)

    query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_month and
            fragment("?::date", w.start) <= ^today and not is_nil(w.end),
        select: %{start: w.start, end: w.end}
      )

    Repo.all(query)
  end

  def get_monthly_working_times(user_id) do
    today = Date.utc_today()
    {:ok, start_of_month} = Date.new(today.year, today.month, 1)

    query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_month and
            not is_nil(w.end),
        select: %{start: w.start, end: w.end}
      )

    Repo.all(query)
  end

  def get_yearly_working_times(user_id) do
    today = Date.utc_today()
    {:ok, start_of_year} = Date.new(today.year, 1, 1)

    query =
      from(w in WorkingTime,
        where:
          w.user == ^user_id and fragment("?::date", w.start) >= ^start_of_year and
            not is_nil(w.end),
        select: %{start: w.start, end: w.end}
      )

    Repo.all(query)
  end
end
