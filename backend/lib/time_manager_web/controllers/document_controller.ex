defmodule TimeManagerWeb.DocumentController do
  use TimeManagerWeb, :controller
  require Logger

  def download(conn, %{"filename" => filename}) do

    file_path = Path.join([:code.priv_dir(:time_manager), "documents", filename])

    if File.exists?(file_path) do
      Logger.info("Téléchargement du fichier : #{file_path}")
      send_download(conn, {:file, file_path})
    else
      Logger.error("Fichier non trouvé : #{file_path}")

      conn
      |> fetch_flash()
      |> put_flash(:error, "Fichier introuvable")
      |> redirect(to: "/")
    end
  end
end
