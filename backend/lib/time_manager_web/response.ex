defmodule TimeManagerWeb.Response do
  @moduledoc """
  Response struct for API responses.
  """

  @derive {Jason.Encoder, only: [:data, :total_pages, :current_page, :page_size]}
  defstruct [:data, :total_pages, :current_page, :page_size]
end
