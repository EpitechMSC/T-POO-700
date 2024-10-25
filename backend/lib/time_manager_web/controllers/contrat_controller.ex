defmodule TimeManagerWeb.ContratController do
  use TimeManagerWeb, :controller

  alias TimeManager.Repo
  alias TimeManager.Contrats
  alias TimeManager.Contrats.Contrat

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    contrats = Contrats.list_contrats()
    json(conn, contrats)
  end

  def create(conn, %{"contrat" => contrat_params}) do
    case Contrats.create_contrat(contrat_params) do
      {:ok, %Contrat{} = contrat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/contrats/#{contrat.id}")
        |> json(%{contrat: contrat})

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def show(conn, %{"id" => id}) do
    case Contrats.get_contrat(id) do
      {:ok, contrat} ->
        json(conn, contrat)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Contrat not found"})
    end
  end

  def update(conn, %{"id" => id, "contrat" => contrat_params}) do
    case Contrats.get_contrat(id) do
      {:ok, contrat} ->
        case Contrats.update_contrat(contrat, contrat_params) do
          {:ok, %Contrat{} = updated_contrat} ->
            json(conn, updated_contrat)

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Contrat not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Contrats.get_contrat(id) do
      {:ok, contrat} ->
        case Contrats.delete_contrat(contrat) do
          {:ok, %Contrat{}} ->
            send_resp(conn, :no_content, "")

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Contrat not found"})
    end
  end
end
