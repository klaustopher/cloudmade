$LOAD_PATH.unshift File.join('..', 'lib')
require 'cloudmade'
require 'test/unit'
require 'test/mock_connection'

include CloudMade

class GeocodingServiceTest < Test::Unit::TestCase #:nodoc: all

  RETURN_DATA_FIND = <<-eos
      {"found": 2, "type": "FeatureCollection",
        "features": [{"properties": {"name": "New Oxford Street"}, "centroid":
          {"type": "POINT", "coordinates": [51.51695, -0.12652]}, "location":
          {"city": "London", "postcode": "WC2"}, "geometry": {"type": "MULTILINESTRING",
          "coordinates": [[[51.5166, -0.12894], [51.51679, -0.12751], [51.51691, -0.12687],
          [51.51704, -0.12587], [51.51717, -0.1251]], [[51.51721, -0.12261], [51.51722, -0.12312]],
          [[51.51639, -0.13042], [51.51653, -0.12954], [51.51654, -0.12948], [51.5166, -0.12894]],
          [[51.51722, -0.12312], [51.51717, -0.12498], [51.51717, -0.1251]], [[51.51717, -0.12498],
          [51.51722, -0.12503]]]}, "id": 490249, "bounds": [[51.51639, -0.13042], [51.51722, -0.12261]]},
          {"properties": {"name": "Oxford Street"}, "centroid": {"type": "POINT", "coordinates":
          [51.51499, -0.14448]}, "location": {"city": "London", "postcode": "SE1"},
          "geometry": {"type": "MULTILINESTRING", "coordinates": [[[51.51341, -0.15853],
          [51.51342, -0.15821], [51.51371, -0.15593], [51.5139, -0.15381], [51.51404, -0.15257], [51.51411, -0.15195],
          [51.51418, -0.15132], [51.51424, -0.15072], [51.51424, -0.15068], [51.51427, -0.15029], [51.51434, -0.14986],
          [51.51442, -0.14919], [51.51445, -0.149], [51.5145, -0.14851], [51.51457, -0.14798], [51.51459, -0.1478],
          [51.51469, -0.14691], [51.51476, -0.14639], [51.51477, -0.14631], [51.51485, -0.1457], [51.51501, -0.1443],
          [51.51521, -0.14269], [51.51528, -0.14213], [51.5153, -0.142]], [[51.5153, -0.142], [51.51537, -0.14137],
          [51.51545, -0.14073]], [[51.51545, -0.14073], [51.5155, -0.14036], [51.51556, -0.13991], [51.5156, -0.13935],
          [51.51568, -0.13863], [51.51577, -0.13771], [51.51581, -0.13732], [51.51585, -0.13678], [51.51594, -0.13586],
          [51.51598, -0.13537], [51.51603, -0.13468], [51.51609, -0.13405], [51.51624, -0.13289], [51.51626, -0.13267],
          [51.51634, -0.13166], [51.51639, -0.13042]]]}, "id": 500456, "bounds": [[51.51341, -0.15853], [51.51639, -0.13042]]}],
          "bounds": [[51.51341, -0.15853], [51.51722, -0.12261]],
          "crs": {"type": "EPSG", "properties": {"code": 4326, "coordinate_order": [0, 1]}}}
    eos

  RETURN_DATA_CLOSEST =<<-eos
  {"found": 1, "type": "FeatureCollection", "features": [{"properties": {"power": "tower"},
    "location": {"city": "Kingston upon Hull", "postcode": "DN37"}, "centroid": {"type": "POINT",
    "coordinates": [53.52435, -0.143]}, "id": 75035, "bounds": [[53.52435, -0.143], [53.52435, -0.143]]}],
    "bounds": [[53.52435, -0.143], [53.52435, -0.143]],
    "crs": {"type": "EPSG", "properties": {"code": 4326, "coordinate_order": [0, 1]}}}
  eos

  def test_find
    connection = MockConnection.new('FAKE-API-KEY', 'fake-cloudmade.com')
    connection.return_data = RETURN_DATA_FIND
    geocoding = GeocodingService.new(connection, 'geocoding')
    geo_results = geocoding.find('/geocoding/find/Oxford%20street%2CLondon.js?bbox_only=True&skip=0&return_location=True&results=2&return_geometry=True')
    assert geo_results.found == 2
    assert_equal geo_results.bounds, BBox.from_coordinates([[51.51341,-0.15853],[51.51722,-0.12261]])
    assert geo_results.results[0].properties["name"] == "New Oxford Street"
    assert geo_results.results[1].properties["name"] == "Oxford Street"
    assert_equal geo_results.results[1].geometry.class.to_s, 'CloudMade::MultiLine'
    assert_equal geo_results.results[1].location.city, "London"
  end

  def test_closest
    connection = MockConnection.new('FAKE-API-KEY', 'fake-cloudmade.com')
    connection.return_data = RETURN_DATA_CLOSEST
    geocoding = GeocodingService.new(connection, 'geocoding')
    geo_result = geocoding.find_closest("poi", 53.51722, -0.12312,
      :options => { :return_location => true, :return_geometry => false})
    assert_equal geo_result.class.to_s, 'CloudMade::GeoResult'
    #assert_equal connection.uri, """/geocoding/closest/poi/53.51722,-0.12312.js?return_location=True&return_geometry=False"""
    assert_nil geo_result.geometry
    assert_equal geo_result.location.city, 'Kingston upon Hull'
    assert_equal geo_result.centroid, Point.new(53.52435, -0.143)
  end
end