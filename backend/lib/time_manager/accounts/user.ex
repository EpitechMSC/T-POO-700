defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email]}
  schema "users" do
    field :username, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/, message: "is invalid")
    |> unique_constraint(:email, message: "Email has already been taken")
    |> unique_constraint(:username, message: "Username has already been taken")
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/, message: "is invalid")
    |> unique_constraint(:email, message: "Email has already been taken", name: :users_email_index)
    |> unique_constraint(:username, message: "Username has already been taken", name: :users_username_index)
  end
end
