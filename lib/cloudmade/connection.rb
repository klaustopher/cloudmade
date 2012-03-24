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
  # This +Connection+ class provides a connection to CloudMade online services (HTTP API).
  # Normally you don't need to create it directly. Construct a 'Client' from parameters instead.
  #
  # Connection examples:
  #
  # conn = CloudMade::Connection.new('cloudmade.com', 80, 'FAKE_API_KEY')
  # CloudMade.Client.new(conn)
  #
  class Connection
    attr_accessor :base_url
    attr_writer :port
    attr_accessor :api_key

    # Initializes connection
    # * +base_url+ should not start with 'www'
    # * +port+ integer value of port for CloudMade portal, if nil then default 80 port is used
    # * +api_key+ your API key to connect to CloudMade services
    def initialize(api_key = nil, base_url = 'cloudmade.com', port = nil)
      self.api_key = api_key
      self.base_url = base_url
      self.base_url = 'cloudmade.com' if self.base_url == nil or self.base_url.empty?
      self.port = port
    end

    # Make a HTTP connection and send a request. Called by the cloudmade 'Client' object internally
    def connect(server_url, request)
      #sputs "#{server_url} #{request}"
      result = nil
      Net::HTTP.start(server_url, self.port) {|http|
        req = Net::HTTP::Get.new("#{request}")
        response = http.request(req)
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          result = response.body
        else
          raise HTTPError.new("Couldn't read data. HTTP status: #{response}")
        end
      }
      return result
    end

    # Convenience method. Return the base URL and port of this Connection
    def url
      return "#{@base_url}#{@port != nil ? ':' + port.to_s : ''}"
    end

    # Port number of this Connection
    def port
      return 80 if @port == nil
      @port
    end
  end
end