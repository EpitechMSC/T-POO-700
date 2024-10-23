defmodule TimemanagerWeb.Decorators.EnsureRole do
  use Decorator.Define, is_granted: 1

  def is_granted(roles, body, %{args: [conn, _params]}) do
    quote do
      current_user_role = unquote(conn).assigns[:current_user]["role"]

      if Enum.any?(unquote(roles), fn role -> role == current_user_role end) do
        unquote(body)
      else
        unquote(conn)
        |> put_status(:forbidden)
        |> json(%{error: "Access Forbidden."})
        |> halt()
      end
    end
  end
end
