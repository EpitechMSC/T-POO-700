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

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: unique_username,
        email: unique_email
      })
      |> TimeManager.Accounts.create_user()

    user
  end

  @doc """
  Generate a user token.
  """
  def user_token_fixture(user) do
    case JWT.generate_and_sign(%{
      "user_id" => user.id,
      "exp" => DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix()
    }, JWT.signer()) do
      {:ok, token, _claims} -> token
      {:error, reason} -> raise "Failed to generate token: #{inspect(reason)}"
    end
  end
end
