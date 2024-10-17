defmodule TimeManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Accounts` context.
  """

  alias TimeManager.JWT

  @doc """
  Generate a unique user.
  """
  def user_fixture(attrs \\ %{}) do
    unique_username = "user_#{System.unique_integer()}"
    unique_email = "user_#{System.unique_integer()}@example.com"
    password = "password_#{System.unique_integer()}"
    role = role_fixture()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: unique_username,
        email: unique_email,
        password: password,
        role_id: role.id
      })
      |> TimeManager.Accounts.create_user()

    user
  end

  @doc """
  Generate a user token.
  """
  def user_token_fixture(user) do
    case JWT.generate_and_sign(
           %{
             "user_id" => user.id,
             "exp" => DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix()
           },
           JWT.signer()
         ) do
      {:ok, token, _claims} -> token
      {:error, reason} -> raise "Failed to generate token: #{inspect(reason)}"
    end
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "role_#{System.unique_integer()}"
      })
      |> TimeManager.Accounts.create_role()

    role
  end
end
