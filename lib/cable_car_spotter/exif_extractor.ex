defmodule CableCarSpotter.ExifExtractor do
  def extract_metadata_from_photo(image_path) do
    case Exexif.exif_from_jpeg_file(image_path) do
      {:ok, info} -> extract_from_valid_exif(info)
      {:error, _} -> %{}
    end
  end

  defp extract_from_valid_exif(%{ gps: gps, exif: exif}) do
    %{
      geom: extract_geo_point(gps),
      photo_taken_at: datetime_original(exif)
    }
  end

  defp extract_from_valid_exif(%{ exif: exif}) do
    %{
      photo_taken_at: datetime_original(exif)
    }
  end

  defp extract_geo_point(%{gps_latitude: lat, gps_latitude_ref: lat_ref, gps_longitude: lng, gps_longitude_ref: lng_ref}) do
    %Geo.Point{
      coordinates: {
        from_dms_to_decimal(lat, lat_ref),
        from_dms_to_decimal(lng, lng_ref)
      },
      srid: 4326
    }
  end

  defp datetime_original(%{ datetime_original: given_dt}), do: parse_datetime_original(given_dt)
  defp datetime_original(_), do: nil

  defp parse_datetime_original(datetime_original) do
    case Timex.parse(datetime_original, "%Y:%m:%d %H:%M:%S", :strftime) do
      {:ok, datetime_taken} -> datetime_taken
      _ -> nil
    end
  end

  defp from_dms_to_decimal([d, m, s], ref) do
    decimal_version = d + m/60.0 + s/3600.0

    case String.upcase(ref) do
      "W" -> decimal_version * -1
      "S" -> decimal_version * -1
      _   -> decimal_version
    end
  end
end
