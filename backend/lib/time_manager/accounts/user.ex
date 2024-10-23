defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :username, :email, :role, :contrat]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :id
    field :contrat, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :role])
    |> validate_required([:email, :username, :role])
    |> validate_password(attrs)
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      message: "is invalid"
    )
    |> unique_constraint(:email, message: "Email has already been taken")
    |> unique_constraint(:username, message: "Username has already been taken")
    |> hash_password()
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :role])
    |> validate_required([:email])
    |> validate_password(attrs, true)
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
    |> hash_password()
  end

  defp validate_password(changeset, _attrs, update \\ false) do
    if _password = get_change(changeset, :password) do
      changeset
      |> validate_length(:password, min: 6, message: "Password must be at least 6 characters")
    else
      if update do
        changeset
      else
        changeset
        |> add_error(:password, "Password is required")
      end
    end
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
