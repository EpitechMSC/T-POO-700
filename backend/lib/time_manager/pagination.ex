defmodule TimeManager.Pagination do

  def paginate(query, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    page_size = Map.get(params, "page_size", Application.get_env(:time_manager, :pagination)[:page_size] || 10)

    query
    |> TimeManager.Repo.paginate(page: page, page_size: page_size)
  end

end
