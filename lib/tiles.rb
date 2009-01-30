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

include CloudMade

module CloudMade

  # Class that is responsible for tile services of Cloudmade
  class TilesService < Service
    attr_accessor :default_tile_size
    attr_accessor :default_style_id

    def initialize(client, subdomain, options = {})
      super(client, subdomain)
      @default_tile_size = (options.has_key? 'tile_size') ? options['tile_size'] : 256
      @default_style_id = (options.has_key? 'style_id') ? options['style_id'] : 1
    end

    # Convert latitude, longitude pair to tile coordinates. Returns tile coordinates as a CloudMade::Point object
    # * +lat+ Latitude
    # * +lon+ Longitude
    # * +zoom+ Zoom level
    def latlon2tilenums(lat, lon, zoom)
      factor = 2**(zoom - 1)
      lat = radians(lat)
      lon = radians(lon)
      xtile = 1 + lon / Math::PI
      ytile = 1 - Math.log(Math.tan(lat) + (1 / Math.cos(lat))) / Math::PI
      return Point.new((xtile * factor).to_i, (ytile * factor).to_i)
    end

    # Convert tile coordinates pair to latitude, longitude. Returns latitude, longitude as a CloudMade::Point object
    # * +xtile+ X coordinate of the tile
    # * +ytile+ Y coordinate of the tile
    # * +zoom+ Zoom level
    def tilenums2latlon(xtile, ytile, zoom)
      factor = 2.0 ** zoom
      lon = (xtile * 360 / factor) - 180.0
      lat = Math.atan(Math.sinh(Math::PI * (1 - 2 * ytile / factor)))
      return Point.new(degrees(lat), lon)
    end

    # :nodoc:
    def radians(degrees)
      Math::PI * degrees / 180
    end

    def degrees(radians)
      radians * 180 / Math::PI
    end

    def xtile(lon, zoom)
      factor = 2**(zoom - 1)
      xtile = 1 + lon / 180.0
      return (xtile * factor).to_i
    end

    def ytile(lat, zoom)
      factor = 2**(zoom - 1)
      lat = radians(lat)
      ytile = 1 - Math.log(Math.tan(lat) + (1 / Math.cos(lat))) / Math::PI
      return (ytile * factor).to_i
    end

    # Get tile with given latitude, longitude and zoom.
    # Returns Raw PNG data which could be saved to file
    #
    # * +lat+ Latitude of requested tile
    # * +lon+ Longitude of requested tile
    # * +zoom+ Zoom level, on which tile is being requested
    # * +style_id+ CloudMade's style id, if not given, default style is used (usually 1)
    # * +tile_size+ size of tile, if not given the default 256 is used
    def get_tile(lat, lon, zoom, style_id = nil, tile_size = nil)
      get_xy_tile(xtile(lon, zoom), ytile(lat, zoom), zoom, style_id, tile_size)
    end

    # Get tile with given x, y numbers and zoom
    # Returns Raw PNG data which could be saved to file
    #
    # * +xtile+
    # * +ytile+
    # * +zoom+ Zoom level, on which tile is being requested
    # * +style_id+ CloudMade's style id, if not given, default style is used (usually 1)
    # * +tile_size+ size of tile, if not given the default 256 is used
    def get_xy_tile(xtile, ytile, zoom, style_id = nil, tile_size = nil)
      style_id = self.default_style_id if style_id == nil
      tile_size = self.default_tile_size if tile_size == nil
      connect "/#{style_id}/#{tile_size}/#{zoom}/#{xtile}/#{ytile}.png"
    end
  end

end