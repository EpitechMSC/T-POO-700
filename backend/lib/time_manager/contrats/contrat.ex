defmodule TimeManager.Contrats.Contrat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contrats" do
    field :temps, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contrat, attrs) do
    contrat
    |> cast(attrs, [:temps])
    |> validate_required([:temps])
  end
end
