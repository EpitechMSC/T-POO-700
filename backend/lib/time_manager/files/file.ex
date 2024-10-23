defmodule TimeManager.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
