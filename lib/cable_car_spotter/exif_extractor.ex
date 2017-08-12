defmodule CableCarSpotter.ExifExtractor do
  def extract_metadata_from_photo(image_path) do
    case Exexif.exif_from_jpeg_file(image_path) do
      {:ok, info} -> extract_from_valid_exif(info)
      {:error, _} -> %{}
    end
  end

  defp extract_from_valid_exif(exif_data) do
    %{
      geom: %Geo.Point{
        coordinates: {
          from_dms_to_decimal(exif_data.gps.gps_latitude, exif_data.gps.gps_latitude_ref),
          from_dms_to_decimal(exif_data.gps.gps_longitude, exif_data.gps.gps_longitude_ref)
        },
        srid: 4326
      },
      photo_taken_at: datetime_original(exif_data.exif)
    }
  end

  defp datetime_original(exif) do
    case Map.has_key?(exif, :datetime_original) do
      true -> parse_datetime_original(exif.datetime_original)
      _    -> nil
    end
  end

  defp parse_datetime_original(datetime_original) do
    case Timex.parse(datetime_original, "%Y:%m:%d %H:%M:%S", :strftime) do
      {:ok, datetime_taken} -> datetime_taken
      _ -> nil
    end
  end

  defp from_dms_to_decimal(dms, ref) do
    [d, m, s] = dms
    decimal_version = d + m/60.0 + s/3600.0

    case String.upcase(ref) do
      "W" -> decimal_version * -1
      "S" -> decimal_version * -1
      _   -> decimal_version
    end
  end

end
