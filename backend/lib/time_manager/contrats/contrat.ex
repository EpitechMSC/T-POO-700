defmodule TimeManager.Contrats.Contrat do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  schema "contrats" do
    field :temps, :integer
    field :upload, TimeManagerWeb.Uploaders.FileUploader.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contrat, attrs) do
    contrat
    |> cast(attrs, [:temps])
    |> validate_required([:temps])
  end
end
