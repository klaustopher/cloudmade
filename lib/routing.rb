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

require 'cgi'
require 'json'

module CloudMade

  #Class corresponding for CloudMade's routing service
  class RoutingService < Service

    ROUTE_TYPES = ['car', 'foot', 'bicycle']
    OUTPUT_FORMATS = ['js', 'json', 'gpx']
    STATUS_OK = 0
    STATUS_ERROR = 1
    EARTHS_DIRECTIONS = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    TURN_TYPE = ["C", "TL", "TSLL", "TSHL", "TR", "TSLR", "TSHR", "U"]

    # Build route. Returns route that was found, instance of CloudMade::Route
    # * +start_point+ Starting point
    # * +end_point+ Ending point
    # * +route_type+ Type of route, e.g. 'car', 'foot', etc.
    # * +transit_points+ List of points route must visit before
    #   reaching end. Points are visited in the same order they are
    #   specified in the sequence.
    # * +route_type_modifier+ Modifier of the route type
    # * +lang+ Language code in conformance to `ISO 3166-1 alpha-2` standard
    # * +units+ Measure units for distance calculation
    def route(start_point, end_point, transit_points = nil, route_type = 'car', lang = 'en', route_type_modifier = nil)
      transit_points = ",[#{transit_points.map {|point| point.to_latlon}.join(',')}]" if not transit_points == nil
      route_type_modifier = "/#{route_type_modifier}" if not route_type_modifier == nil
      url = "/#{start_point.to_latlon}#{transit_points},#{end_point.to_latlon}/#{route_type}#{route_type_modifier}.js?lang=#{lang}&units=km"
      return Route.new(JSON.parse(connect url))
    end

    #:nodoc:
    def url_template
      return "http://#{@subdomain}.#{@connection.url}/#{@connection.api_key}/api/0.3"
    end
  end


  # Statistics of the route
  class RouteSummary
    attr_accessor :total_distance
    attr_accessor :total_time
    attr_accessor :start_point
    attr_accessor :end_point
    attr_accessor :transit_points

    def initialize(summary)
        self.total_distance = Float(summary['total_distance'])
        self.total_time = Float(summary['total_time'])
        self.start_point = summary['start_point']
        self.end_point = summary['end_point']
        self.transit_points = summary['transit_points']
    end
  end

  # Wrapper around raw data being returned by routing service
  class Route

    # List of route instructions
    attr_accessor :instructions
    # Statistical info about the route
    attr_accessor :summary
    # Geometry of route
    attr_accessor :geometry
    #Version of routing HTTP API
    attr_accessor :version    
    # Status of response
    attr_accessor :status
    attr_accessor :status_message

    STATUS_OK = 0
    STATUS_ERROR = 1

    def initialize(data)
      begin
        self.status = data['status'].to_i
        self.instructions = data['route_instructions'].map { |instruction_data| RouteInstruction.new(instruction_data) }
        self.summary = RouteSummary.new(data['route_summary'])
        self.geometry = Line.new(data['route_geometry'])
        self.version = data['version']
        self.status_message = data['status_message']
      rescue
        raise RouteNotFound
      end
    end

    def to_s
      self.instructions.to_s
    end
  end

  # Instructions on route passing
  class RouteInstruction

    # Text instruction
    attr_reader :instruction
    # Length of the segment in meters
    attr_reader :length
    # Index of the first point of the segment
    attr_reader :position
    # Estimated time required to travel the segment in seconds
    attr_reader :time
    # Length of the segments in specified units
    attr_reader :length_caption
    # Earth direction
    attr_reader :earth_direction
    # North-based azimuth
    attr_reader :azimuth
    # Code of the turn type
    attr_reader :turn_type
    # Angle in degress of the turn between two segments
    attr_reader :turn_angle

    def initialize(data)
      @instruction = data[0]
      @length = Float(data[1])
      @position = Integer(data[2])
      @time = Integer(data[3])
      @length_caption = data[4]
      @earth_direction = data[5]
      @azimuth = Float(data[6])
      if data.length == 9
        @turn_type = data[7]
        @turn_angle = data[8]
      end
    end
  end
end