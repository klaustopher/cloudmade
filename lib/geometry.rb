#
# Copyright 2009 CloudMade.
#
# Licensed under the GNU Lesser General Public License, Version 3.0;
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module CloudMade
  class Geometry

    class << self
      def parse(data)
        return nil if data == nil
        case data['type'].downcase
        when 'point' then return Point.new(data['coordinates'])
        when 'line' then return Line.new(data['coordinates'])
        when 'multilinestring' then return MultiLine.new(data['coordinates'])
        when 'polygon' then return Polygon.new(data['coordinates'])
        when 'multipolygon' then return MultiPolygon.new(data['coordinates'])
        end
      end
    end
  end

  class Point < Geometry
    attr_accessor :lat
    attr_accessor :lon

    # Posible initializers are
    # Point.new(1, -1)
    # Point.new([1, -1])
    def initialize(*args)
      if args.size == 1
        @lat = args[0][0]
        @lon = args[0][1]
      elsif args.size == 2
        @lat = args[0]
        @lon = args[1]
      end
    end

    def ==(point)
      return (point.lat == @lat and point.lon == @lon)
    end

    def to_s
      "Point(#{@lat},#{@lon})"
    end

    def to_latlon
      "#{@lat},#{@lon}"
    end
  end

  class Line < Geometry
    attr_accessor :points

    def initialize(coords)
      @points = coords.map { |latlng| Point.new(latlng) }
    end

    def to_s
      "Line(#{@points.join(',')})"
    end
  end


  class MultiLine < Geometry
    attr_accessor :lines

    def initialize(coords)
      @lines = coords.map { |line_coords| Line.new(line_coords) }
    end

    def to_s
      "MultiLine(#{@lines.join(',')})"
    end
  end

  class Polygon < Geometry
    attr_accessor :border_line
    attr_accessor :holes

    def initialize(coords)
      @border_line = Line.new(coords[0])
      @holes = coords.slice(1, coords.length).map { |line_coords| Line.new(line_coords) }
    end

    def to_s
      "Polygon(#{@border_line} - (#{@holes.join(',')}))"
    end
  end

  class MultiPolygon < Geometry
    attr_accessor :polygons

    def initialize(coords)
      @polygons = coords.map { |poly_coords| Polygon.new(poly_coords) }
    end

    def to_s
      "MultiPolygon(#{@polygons.join(',')})"
    end
  end

  class BBox < Geometry
    attr_accessor :points
    
    def initialize(points)
      self.points = points
    end

    class << self
      def from_points(points)
        return BBox.new(points)
      end

      def from_coordinates(coords)
        point1 = Point.new(coords[0][0], coords[0][1])
        point2 = Point.new(coords[1][0], coords[1][1])
        return BBox.new([point1, point2])
      end
    end

    def ==(bbox)
      return (bbox.points[0] == self.points[0] and bbox.points[1] = self.points[1] or
          bbox.points[0] == self.points[1] and bbox.points[1] = self.points[0])
    end
  end
end