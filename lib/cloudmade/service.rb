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

  # General class for all CloudMade's services
  class Service
    require 'net/http'
    require 'cgi'
    attr_accessor :subdomain
    attr_accessor :connection

    def url_template
      return "http://#{@subdomain}.#{@connection.url}/#{@connection.api_key}"
    end

    # Template for service's domain
    # By default it is <service_name>.cloudmade.com
    # E.g. tile.cloudmade.com, geocoding.cloudmade.com
    def url
      "#{@subdomain}.#{@connection.base_url}"
    end

    class << self
      def to_url_params(params)
        params.map {|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join('&')
      end
    end

    protected
      def initialize(connection, subdomain)
        self.connection = connection
        self.subdomain = subdomain
      end

      def connect(request)
        return @connection.connect(url, "#{url_template}#{request}")
      end
  end
end