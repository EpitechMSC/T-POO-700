defmodule TimeManager.JWT do
  use Joken.Config

  @secret "AcV3l!139o^£XQ[>j&S%"

  @impl true
  def token_config do
    default_claims()
    |> add_claim("user_id", nil, &(&1 != nil))
    |> add_claim("exp", nil, &(&1 > current_unix_time()))
  end

  @spec signer :: Joken.Signer.t()
  def signer do
    Joken.Signer.create("HS256", @secret)
  end

  defp current_unix_time do
    DateTime.utc_now() |> DateTime.to_unix()
  end

  def generate_token(user_id) do
    claims = %{"user_id" => user_id, "exp" => current_unix_time() + 3600}
    Joken.generate_and_sign(claims, signer())
  end
end
