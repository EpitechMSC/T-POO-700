defmodule TimeManager.Work.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user]}
  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end])
  end
end
