defmodule CableCarSpotter.Photo do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @versions [:original, :thumbnail]

  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  # Define a thumbnail transformation:
  def transform(:thumbnail, _) do
    {:convert, "-strip -thumbnail 320x430 -gravity center -limit area 10MB -limit disk 50MB"}
  end

  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    uuid = UUID.uuid5(:url, file.file_name, :hex)
    "sightings/#{scope.user_id}/#{scope.cable_car_id}/#{uuid}/#{version}"
  end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    CableCarSpotterWeb.Endpoint.url <> "/images/default_cable_car.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
