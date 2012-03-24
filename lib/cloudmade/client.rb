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
  class Client
    attr_accessor :connection
    attr_accessor :base_url
    attr_writer :port
    attr_accessor :api_key
    #attr_reader :token

    #:nodoc:
    def url
      return "#{base_url}#{@port != nil ? ':' + port.to_s : ''}"
    end

    #:nodoc:
    def port
      return 80 if @port == nil
      @port
    end

    # Tiles service
    def tiles
      @tiles = TilesService.new(self.connection, 'tile') if @tiles == nil
      return @tiles
    end

    # Geocoding service
    def geocoding
      @geocoding = GeocodingService.new(self.connection, 'geocoding') if @geocoding == nil
      return @geocoding
    end

    # Routing service
    def routing
      @routing = RoutingService.new(self.connection, 'routes') if @routing == nil
      return @routing
    end

    # Locations service
    def locations
      @locations = LocationsService.new(self.connection, '') if @locations == nil
      return @locations
    end

    class << self
      def from_connection(connection)
        client = Client.new
        client.connection = connection
        return client
      end

      def from_parameters(api_key, base_url = nil, port = nil)
        client = Client.new
        client.connection = Connection.new(api_key, base_url, port)
        return client
      end

      # TODO: Create here methods to connect from XML and YAML configuration file
    end
    
    protected
      def initialize()
      end
    ### 2. Allow loads configuration from XML, YAML files
    #def initialize(api_key, base_url = 'cloudmade.com', port = nil)
    #  @base_url = base_url
    #  @port = port
    #  @api_key = api_key
    #  #@token = token
    #end
  end
end