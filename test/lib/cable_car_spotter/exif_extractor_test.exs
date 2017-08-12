defmodule CableCarSpotter.ExifExtractorTest do
  use CableCarSpotter.ConnCase

  describe "when the given photo has exif data" do
    test "the gps and timestamp are returned" do
      image_path = "test/fixtures/cable_car_with_exif.jpg"
      result = CableCarSpotter.ExifExtractor.extract_metadata_from_photo(image_path)
      refute result == %{}
      assert Map.has_key?(result, :geom)
      assert Map.has_key?(result, :photo_taken_at)
    end
  end

  describe "when the given photo has GPS but does not have datetime data" do
    test "the photo_taken_at field is left blank" do
      image_path = "test/fixtures/cable_car_without_datetime.jpg"
      assert CableCarSpotter.ExifExtractor.extract_metadata_from_photo(image_path).photo_taken_at == nil
    end
  end

  describe "when the given photo does not have exif data" do
    test "an empty object is returned" do
      image_path = "test/fixtures/cable_car_without_exif.jpg"
      assert CableCarSpotter.ExifExtractor.extract_metadata_from_photo(image_path) == %{}
    end
  end
end
