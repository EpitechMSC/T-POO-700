defmodule TimeManagerWeb.SignalJSON do
  alias TimeManager.Signals.Signal

  @doc """
  Renders a list of signals.
  """
  def index(%{signals: signals}) do
    %{data: for(signal <- signals, do: data(signal))}
  end

  @doc """
  Renders a single signal.
  """
  def show(%{signal: signal}) do
    %{data: data(signal)}
  end

  defp data(%Signal{} = signal) do
    %{
      id: signal.id,
      name: signal.name,
      status: signal.status
    }
  end
end
