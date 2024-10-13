defmodule TimeManagerWeb.Response do
  @moduledoc """
  Response struct for API responses.
  """

  @derive {Jason.Encoder, only: [:data, :pagination]}
  defstruct [:data, :pagination]
end
