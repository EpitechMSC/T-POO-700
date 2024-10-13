defmodule TimeManager.Pagination do
  @moduledoc """
  Handles pagination logic for database queries.
  """

  import Ecto.Query, only: [limit: 2, offset: 2]
  alias TimeManager.Repo
  alias TimeManagerWeb.Response

  @doc """
  Paginates the given Ecto query based on the provided parameters.

  ## Parameters

    - `query` (Ecto.Query): The Ecto query to paginate.
    - `params` (map): A map containing "page" and "page_size" as strings.

  ## Returns

    - `{:ok, paginated_result}`: On success, it returns the query result with pagination info.
    - `{:error, reason}`: On failure, it returns the error reason.

  ## Examples

      iex> Pagination.paginate(WorkingTime, %{"page" => "1", "page_size" => "10"})
      {:ok, %{data: [...], pagination: %{total_pages: 5, current_page: 1, page_size: 10}}}
  """
  def paginate(query, params) do
    with {:ok, page} <- parse_positive_integer(Map.get(params, "page", "1"), "page"),
         {:ok, page_size} <- parse_positive_integer(Map.get(params, "page_size", "10"), "page_size") do
      total_count = Repo.aggregate(query, :count, :id)

      paginated_query =
        query
        |> limit(^page_size)
        |> offset(^((page - 1) * page_size))
        |> Repo.all()

      total_pages = div(total_count + page_size - 1, page_size)

      pagination_info = %{
        total_pages: total_pages,
        current_page: page,
        page_size: page_size
      }

      {:ok, %Response{
        data: paginated_query,
        pagination: pagination_info
      }}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp parse_positive_integer(value, field) do
    case Integer.parse(value) do
      {int, ""} when int > 0 -> {:ok, int}
      _ -> {:error, "#{field} must be a positive integer"}
    end
  end
end
