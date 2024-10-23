defmodule TimeManagerWeb.ContratController do
  use TimeManagerWeb, :controller

  alias TimeManager.Repo
  alias TimeManager.Contrats
  alias TimeManager.Contrats.Contrat

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    contrats = Contrats.list_contrats()
    render(conn, :index, contrats: contrats)
  end

  def create(conn, %{"contrat" => contrat_params}) do
    with {:ok, %Contrat{} = contrat} <- Contrats.create_contrat(contrat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/contrats/#{contrat}")
      |> render(:show, contrat: contrat)
    end
  end

  def show(conn, %{"id" => id}) do
    contrat = Contrats.get_contrat!(id)
    render(conn, :show, contrat: contrat)
  end

  def update(conn, %{"id" => id, "contrat" => contrat_params}) do
    contrat = Contrats.get_contrat!(id)

    with {:ok, %Contrat{} = contrat} <- Contrats.update_contrat(contrat, contrat_params) do
      render(conn, :show, contrat: contrat)
    end
  end

  def delete(conn, %{"id" => id}) do
    contrat = Contrats.get_contrat!(id)

    with {:ok, %Contrat{}} <- Contrats.delete_contrat(contrat) do
      send_resp(conn, :no_content, "")
    end
  end
end
