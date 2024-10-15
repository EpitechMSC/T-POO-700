defmodule TimeManager.Signals.Signal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "signals" do
    field :name, :string
    field :status, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(signal, attrs) do
    signal
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
