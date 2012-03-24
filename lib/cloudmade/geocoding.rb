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
  require 'cgi'

  # Class that is responsible for geocoding services of Cloudmade
  class GeocodingService < Service

    # Find objects that match given query. Returns GeoResults object.
    #
    # * +query+ Query by which objects should be searched
    # * +options+ Additional options, contains
    # results: How many results should be returned.
    # skip: Number of results to skip from beginning.
    # bbox: Bounding box in which objects should be searched.
    # bbox_only: If set to False, results will be searched in the whole world if there are no results for a given bbox.
    # return_geometry: If specified, adds geometry in returned results. Defaults to true.
    #
    def find(query, options = {})
      options['results'] = 10 unless options.has_key? 'results'
      options['skip'] = 0 unless options.has_key? 'skip'
      options['bbox_only'] = true unless options.has_key? 'bbox_only'
      options['return_geometry'] = true unless options.has_key? 'return_geometry'
      request = "/find/#{CGI.escape(query)}.js?#{Service.to_url_params(options)}"
      GeoResults.new(JSON.parse(connect request))
    end

    # Find closest object to a given point.
    # For a list of available object types, see:
    # http://www.cloudmade.com/developers/docs/geocoding-http-api/object_types
    # Returns GeoResult object, that contain found objects.
    # Raise ObjectNotFound: Raised when no object could be found in radius of 50 km from point.
    #
    # * +object_type+ Type of object, that should be searched.
    # * +point+ Closest object to this point will be searched.
    # * +options+ are
    # * +return_geometry+ If specified, adds geometry in returned results. Defaults to true

    # TODO: Modify lat, lon parameters to point
    def find_closest(object_type, lat, lon, options = {})
      lat_lon = "#{CGI.escape(lon.to_s + '+' + lat.to_s)}"
      request = "/closest/#{object_type}/#{lat_lon}.js?#{Service.to_url_params(options)}"
      geo_results = GeoResults.new(JSON.parse(connect request))
      raise ObjectNotFound.new if (geo_results.results == nil or geo_results.results.size == 0)
      return geo_results.results[0]
    end

    # :nodoc:
    def url_template
      return "http://#{@subdomain}.#{@connection.url}/#{@connection.api_key}/geocoding"
    end
  end

  # Location of the object in geographical terms
  class Location
    # road: Road on which object is situated
    attr_accessor :road
    # city: City, where the object is situated
    attr_accessor :city
    # county: County, where the object is situated
    attr_accessor :county
    # country: Country in which the object is situated
    attr_accessor :country
    # postcode: Postcode, which corresponds to location of the object
    attr_accessor :postcode

    def initialize(data)
      self.road = data['road']
      self.city = data['city']
      self.county = data['county']
      self.country = data['country']
      self.postcode = data['postcode']
    end
  end

  # Parsed results of geocoding request
  class GeoResults
    # Founded results
    attr_accessor :found
    # List of found GeoResult objects
    attr_accessor :results
    # Bounds of result set
    attr_accessor :bounds

    def initialize(data)
      self.found = Integer(data['found'])
      if (data['features'] != nil) then
        self.results = data['features'].map { |feature_data| CloudMade::GeoResult.new(feature_data) }
      end
      self.bounds = CloudMade::BBox.from_coordinates(data['bounds']) if data.has_key? 'bounds'
    end

    def to_s
      results.join(',') if results != nil
    end
  end

  class GeoResult
    # Id of the object
    attr_accessor :id
    # Geometry of the object
    attr_accessor :geometry
    # Centroid of the object
    attr_accessor :centroid
    # Bounds of result set
    attr_accessor :bounds
    # Properties of the object
    attr_accessor :properties
    # Location of the object
    attr_accessor :location

    def initialize(data)
      self.id = data['id']
      self.geometry = CloudMade::Geometry.parse(data['geometry'])
      self.centroid = CloudMade::Geometry.parse(data['centroid'])
      self.bounds = CloudMade::BBox.from_coordinates(data['bounds']) if data.has_key? 'bounds'
      self.properties = data['properties']
      if data.has_key? 'location'
        self.location = Location.new(data['location'])
      else
        self.location = nil
      end
    end

    def to_s
      self.geometry.to_s
    end
  end
end