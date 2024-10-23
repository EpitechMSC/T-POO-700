defmodule TimeManagerWeb.Uploaders.FileUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  def validate({file, _}) do
    ~w(.pdf .odt) |> Enum.member?(Path.extname(file.file_name))
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/files/#{scope.id}"
  end
end
