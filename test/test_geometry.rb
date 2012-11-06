$:.push File.expand_path("../../lib", __FILE__)
$:.push File.expand_path("../..", __FILE__)

require 'cloudmade'
require 'test/unit'

class PointTest < Test::Unit::TestCase #:nodoc: all
  
  def test_initialization
    point = CloudMade::Point.new(1, 2)
    assert_equal point.lat, 1
    assert_equal point.lon, 2

    point = CloudMade::Point.new([1, 3])
    assert_equal point.lat, 1
    assert_equal point.lon, 3
  end

  def test_equality
    point1 = CloudMade::Point.new(1, 0)
    point2 = CloudMade::Point.new(2/2, 1-1)
    assert point1 == point2

    point3 = CloudMade::Point.new(1.0, 0.1)
    assert point1 != point3
  end

  def test_to_latlon
    point = CloudMade::Point.new(1, 2)
    assert_equal point.to_latlon, '1,2'
  end
  
  def test_to_wkt
    point = CloudMade::Point.new(1, 2)
    assert_equal point.to_wkt, 'POINT (1 2)'
  end
end

class LineTest < Test::Unit::TestCase #:nodoc: all

  def test_initialization
    line = CloudMade::Line.new([[1.1, 2.0], [0.1, 2.1]])
    assert_equal line.points.length, 2
    assert_equal line.points[0].lat, 1.1
    assert_equal line.points[0].lon, 2.0
    assert_equal line.points[1].lat, 0.1
    assert_equal line.points[1].lon, 2.1

    line = CloudMade::Line.new([[1.1, 2.0], [0.1, 2.1], [0.5, 3.1], [3.1, 4.1]])
    assert_equal line.points.length, 4
  end
  
  def test_to_wkt
    line = CloudMade::Line.new([[1.1, 2.0], [0.1, 2.1]])
    assert_equal line.to_wkt, 'LINESTRING (1.1 2.0, 0.1 2.1)'
  end
end

class MultiLineTest < Test::Unit::TestCase #:nodoc: all
  def multiline
    coords = [[[0.2, 35.2], [4.3, 45.1], [5.7, 11.2]], [[1.1, 33.2], [5.3, 22.2]]]
    CloudMade::MultiLine.new(coords)
  end
  
  def test_initialization
    assert_equal multiline.lines.size, 2
    assert_equal multiline.lines[0].points.length, 3
    assert_equal multiline.lines[1].points.length, 2
    assert_equal multiline.lines[1].points[0].lon, 33.2
  end
  
  def test_to_wkt
    assert_equal multiline.to_wkt, "MULTILINESTRING ((0.2 35.2, 4.3 45.1, 5.7 11.2), (1.1 33.2, 5.3 22.2))"
  end
end

class PolygonTest < Test::Unit::TestCase #:nodoc: all
  def polygon
    coords = [[[0.2, 35.2], [4.3, 45.1], [5.7, 11.2]], [[1.1, 33.2], [5.3, 22.2]]]
    CloudMade::Polygon.new(coords)    
  end
  
  def test_initialization
    assert polygon.border_line != nil
    assert_equal polygon.border_line.points.size, 3
    assert polygon.holes != nil
    assert_equal polygon.holes.size, 1
  end
  
  def test_to_wkt
    assert_equal polygon.to_wkt, 'POLYGON ((0.2 35.2, 4.3 45.1, 5.7 11.2), (1.1 33.2, 5.3 22.2))'
  end
end

class MultiPolygonTest < Test::Unit::TestCase #:nodoc: all
  def multipolygon
    coords = [[[[0.2, 35.2], [4.3, 45.1]]], [[[1.1, 33.2], [5.3, 22.2]]]]
    CloudMade::MultiPolygon.new(coords)
  end
  
  def test_initialization
    assert_equal multipolygon.polygons.size, 2
    assert_equal multipolygon.polygons[0].holes.size, 0
    assert_equal multipolygon.polygons[1].holes.size, 0
  end
  
  def test_to_wkt
    assert_equal multipolygon.to_wkt, 'MULTIPOLYGON (((0.2 35.2, 4.3 45.1)), ((1.1 33.2, 5.3 22.2)))'
  end
end

class BBoxTest < Test::Unit::TestCase #:nodoc: all
  def test_initialization
    coordinates = [[0.2, 35.2], [4.3, 45.1]]
    point1 = CloudMade::Point.new(coordinates[0])
    point2 = CloudMade::Point.new(coordinates[1])
    bbox = CloudMade::BBox.from_points([point1, point2])
    assert_equal bbox.points.length, 2
    assert_equal bbox.points[0], point1
    assert_equal bbox.points[1], point2

    bbox = CloudMade::BBox.from_coordinates(coordinates)
    assert_equal bbox.points.length, 2
    assert_equal bbox.points[0], point1
    assert_equal bbox.points[1], point2
  end
end

# TODO: add code to parse that
#class GeometryTest < Test::Unit::TestCase #:nodoc: all
#end