defmodule TimeManager.TimeTracker.WorkinTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workin_time, attrs) do
    workin_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
