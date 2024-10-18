defmodule TimeManagerWeb.ContratJSON do
  alias TimeManager.Contrats.Contrat

  @doc """
  Renders a list of contrats.
  """
  def index(%{contrats: contrats}) do
    %{data: for(contrat <- contrats, do: data(contrat))}
  end

  @doc """
  Renders a single contrat.
  """
  def show(%{contrat: contrat}) do
    %{data: data(contrat)}
  end

  defp data(%Contrat{} = contrat) do
    %{
      id: contrat.id,
      temps: contrat.temps
    }
  end
end
