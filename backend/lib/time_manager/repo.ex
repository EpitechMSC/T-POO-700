defmodule TimeManager.Repo do
  use Ecto.Repo,
    otp_app: :time_manager,
    adapter: Ecto.Adapters.Postgres

  @behaviour Scrivener.Paginater

  def paginate(query, opts) do
    Scrivener.paginate(query, opts)
  end
end
