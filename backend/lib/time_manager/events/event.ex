defmodule TimeManager.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :title, :all_day, :team_id]}
  schema "events" do
    field :start, :utc_datetime
    field :title, :string
    field :end, :utc_datetime
    field :all_day, :boolean, default: false
    field :team_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :start, :end, :all_day, :team_id])
    |> validate_required([:title, :start, :team_id])
  end
end
