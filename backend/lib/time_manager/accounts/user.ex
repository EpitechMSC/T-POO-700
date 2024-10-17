defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TimeManager.Accounts.Role
  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :username, :email, :role_id]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    belongs_to :role, Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :role_id])
    |> validate_required([:email, :username, :password, :role_id])
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      message: "is invalid"
    )
    |> unique_constraint(:email, message: "Email has already been taken")
    |> unique_constraint(:username, message: "Username has already been taken")
    |> validate_length(:password, min: 6, message: "Password must be at least 6 characters")
    |> hash_password()
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :role_id])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      message: "is invalid"
    )
    |> unique_constraint(:email,
      message: "Email has already been taken",
      name: :users_email_index
    )
    |> unique_constraint(:username,
      message: "Username has already been taken",
      name: :users_username_index
    )
    |> validate_length(:password, min: 6, message: "Password must be at least 6 characters")
    |> hash_password()
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end
end
